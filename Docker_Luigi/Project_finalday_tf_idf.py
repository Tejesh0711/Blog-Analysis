
# coding: utf-8

# In[ ]:

import pip
def install(package):
   pip.main(['install', package])

install('BeautifulSoup4')
install('webhoseio')
install('textblob')
install('nltk')


# In[1]:

#importing required packages
import webhoseio
import requests
import numpy as np
import pandas as pd
import json
import os
import time
import datetime
import matplotlib.pyplot as plt
import seaborn as sns
import luigi
import boto
import boto.s3
import sys
from boto.s3.key import Key
import glob
import math
from textblob import TextBlob as tb
import string
from nltk.corpus import stopwords


# In[2]:




# In[3]:

#training
def read_data():
    #getting current working directory
    current_directory=os.getcwd()
    root_directory=os.path.abspath(os.path.join(current_directory, os.pardir)) #To get the parent directory of current directory
    #parent_directory=os.path.abspath(os.path.join(root_directory, os.pardir))
    print(current_directory)
    processeddf=pd.read_csv(current_directory+"/tf_final_input.csv",encoding = "ISO-8859-1")
    return processeddf


# In[4]:
def data_cleaning(processeddf):
    processeddf = processeddf.drop(['text'], axis = 1)
    processeddf.rename(columns={'thread_section_title':'text'}, inplace=True) 
    return processeddf
	
def exploratory_data_analysis(processeddf):
    processeddf["published"]=pd.to_datetime(processeddf['published'])
    processeddf["published_day"]=processeddf["published"].dt.day
    
    #Getting country wise daily blog count 
    x1=processeddf.groupby(["published_day","thread_country"])["uuid"].count().reset_index(name="Blog count").sort_values(("Blog count"),ascending=False).head(20)
    
    #Getting country wise daily reply count
    x2=processeddf.groupby(["published_day","thread_country"])["thread_replies_count"].sum().reset_index(name="Reply count").sort_values(("Reply count"),ascending=False).head(20)
    
    fig = plt.figure()
    ax1 = fig.add_subplot(211)
    ax2 = fig.add_subplot(212)

    g1 = sns.factorplot(x="published_day", y="Blog count", hue="thread_country", data=x1, ax=ax1)
    g2 = sns.factorplot(x="published_day", y="Reply count", hue="thread_country", data=x2, ax=ax2)

    #g1.savefig('output.png')

    plt.close(g1.fig)
    plt.close(g2.fig)
    plt.show()

    #From this graph we can conclude that people in US contribute to blogs on a daily basis whereas that is not the case with people from other countries.

    
    analysis2=processeddf.groupby("language")["uuid"].count().reset_index(name="Count").sort_values("Count",ascending=False).head()
    processeddf.groupby(["language","thread_site_type"])["uuid"].count().reset_index(name="Count").sort_values("Count",ascending=False).head(10)
    z1=processeddf[processeddf["thread_replies_count"]!=0]
    z1.groupby("language")["uuid"].count().reset_index(name="Count").sort_values("Count",ascending=False)
    
    return analysis2

def tf(word, blob):
    return blob.words.count(word) / len(blob.words)

def n_containing(word, bloblist):
    return sum(1 for blob in bloblist if word in blob.words)

def idf(word, bloblist):
    return math.log(len(bloblist) / (1 + n_containing(word, bloblist)))

def tfidf(word, blob, bloblist):
    return tf(word, blob) * idf(word, bloblist)
	
def RemoveStopWords(text):
    # Check characters to see if they are in punctuation
    nopunc = [char for char in text if char not in string.punctuation]

    # Join the characters again to form the string.
    nopunc = ''.join(nopunc)
    
    # Now just remove any stopwords
    nonstop_list=[word for word in nopunc.split() if word.lower() not in stopwords.words('english')]
    
    nonstopstring=' '.join(nonstop_list)
    return nonstopstring
	
	
def calculate_tf_idf(processeddf):
    newtype=pd.DataFrame()
    newtype["text"]=processeddf["text"][:10].apply(str)
    tfdf=pd.DataFrame()
    tfdf["text"]=newtype['text'].apply(RemoveStopWords)
    bloblist=[tb(t) for t in tfdf["text"].values]
    
    bag_of_words = pd.DataFrame(columns=['Entertainment','Finance','Hotel','Movie','Political','Sports','Technology','Travel','World'])
    
    processeddf["score"]=0.0
    processeddf["position"]=0.0
    for i, blob in enumerate(bloblist):
        print("document new")
        scores = {word: tfidf(word, blob, bloblist) for word in blob.words}
        sorted_words = sorted(scores.items(), key=lambda x: x[1], reverse=True)
        j = 0;
        for word, score in sorted_words:
            j = j+1
            if word==processeddf["Keyword"][i]:
                print(word,"\t",score)
                print("j >>>",j)
                processeddf["score"][i] = score
                processeddf["position"][i] = (len(sorted_words) - (j))/len(sorted_words)
                position=(len(sorted_words) - (j))/len(sorted_words)
                print("position >> ",position)
                #bag=[]
                labels=[word,"score"]
                df=pd.DataFrame.from_records(sorted_words,columns=labels)
                bag_of_words=pd.concat([bag_of_words,df])
                #for count in np.arange(0,len(sorted_words)):
                    #bag.append(sorted_words[:50][count][0])
                #bags=pd.Series(bag)
                #bag_of_words[word].append(bag)
                break
            else:
                processeddf["score"][i] = -1
                processeddf["position"][i]= -1
    print("tf-idf has been implemented")
    bag_of_words.to_csv("Bag_of_Words.csv", sep=",")
    return processeddf

#uploading files to AWS S3 bucket
def pushToAmazon(accessKey,secretKey):
    #accessKey,secretKey=getAmazonS3keys()
    AWS_ACCESS_KEY_ID = accessKey
    AWS_SECRET_ACCESS_KEY = secretKey
    print(AWS_ACCESS_KEY_ID)
    print(AWS_SECRET_ACCESS_KEY)
    TeamNumber='team10'

    bucket_name = TeamNumber+ 'ads-final-project'
    conn = boto.connect_s3(AWS_ACCESS_KEY_ID,
            AWS_SECRET_ACCESS_KEY)

    try:
        bucket = conn.create_bucket(bucket_name,location=boto.s3.connection.Location.DEFAULT)
        #log_entry("Connection with Amazon S3 bucket is successful.")
    except Exception as e:  
        #log_entry("Amazon access key or secret key is invalid")
        print("Amazon access key or secret key is invalid")
        sys.exit()

    #uploading multiple files
    filenames=[]
    #filenames =glob.glob(".\\'zip_"+str(CIK)+".zip")
    filenames.append("clean_data.csv")
    filenames.append("Analysis2.csv")
    filenames.append("tf-idf_data.csv")
    filenames.append("Bag_of_Words.csv")
    #filenames.append("zip_"+str(CIK)+".zip")


    def percent_cb(complete, total):
        sys.stdout.write('.')
        sys.stdout.flush()

    for fname in filenames:
        bucket = conn.get_bucket(bucket_name)
        key = bucket.new_key(fname).set_contents_from_filename(fname,cb=percent_cb, num_cb=10)
        print ("uploaded file %s" % fname)
        #log_entry("{fname} has been uploaded.".format(fname=fname)) 











# In[ ]:

class DownloadData(luigi.Task):
 
    def requires(self):
        return []
 
    def output(self):
        return luigi.LocalTarget("Main_data.csv")
 
    def run(self):
        processeddf=read_data()
        processeddf.to_csv("Main_data.csv", sep=",")

class CleanData(luigi.Task):
 
    def requires(self):
        return [DownloadData()]
 
    def output(self):
        return luigi.LocalTarget("clean_data.csv")
 
    def run(self):
        cldata = pd.read_csv("Main_data.csv", encoding= 'iso-8859-1',low_memory=False)
        processeddf=data_cleaning(cldata)
        processeddf.to_csv("clean_data.csv", sep=",")
		
		
class ExploratoryAnalysis(luigi.Task):
 
    def requires(self):
        return [CleanData()]
 
    def output(self):
        return luigi.LocalTarget("Analysis2.csv")
 
    def run(self):
        expdata = pd.read_csv("clean_data.csv", encoding= 'iso-8859-1',low_memory=False)
        anal2=exploratory_data_analysis(expdata)
        anal2.to_csv("Analysis2.csv")

class tfidfc(luigi.Task):
 
    def requires(self):
        return [ExploratoryAnalysis()]
 
    def output(self):
        return luigi.LocalTarget("tf-idf_data.csv")
 
    def run(self):
        tfdata = pd.read_csv("clean_data.csv", encoding= 'iso-8859-1',low_memory=False)
        tfdata=calculate_tf_idf(tfdata)
        #tfdata["uuid"][1]
        #bag_of_words["Entertainment"][1]
        tfdata.to_csv("tf-idf_data.csv", sep=",")

class UploadToS3Bucket(luigi.Task):
    awsKey = luigi.Parameter(config_path=dict(section='path',name='aws_key'))
    awsSecret = luigi.Parameter(config_path=dict(section='path',name='aws_secret'))
    def requires(self):
        return [tfidfc()]
 
    def output(self):
        return luigi.LocalTarget("uploadStatus.txt")
 
    def run(self):
        access_key = self.awsKey
        access_secret = self.awsSecret
        pushToAmazon(access_key,access_secret)
        # this will return a file stream that reads the file from your aws s3 bucket\
        with self.output().open('w') as f:
            f.write("Upload Done")


# In[13]:

if __name__ == '__main__':
    luigi.run()# In[ ]:

