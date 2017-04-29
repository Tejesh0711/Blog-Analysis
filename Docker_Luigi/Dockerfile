FROM python:3

USER root

ADD Project_finalday_tf_idf.py Project_finalday_tf_idf.py

RUN apt-get update && \
    apt-get clean && \
        rm -rf /var/lib/apt/lists/*

	USER $NB_USER
    
    # Install Python 3 packages
	# Remove pyqt and qt pulled in for matplotlib since we're only ever going to
	# use notebook-friendly backends in these images
	RUN pip install boto
	RUN pip install luigi
	RUN pip install numpy
	RUN pip install pandas
	
	RUN pip install os
	RUN pip install time
	RUN pip install datetime
	RUN pip install seaborn
	RUN pip install sys
	RUN pip install glob
	RUN pip install math
	RUN pip install TextBlob
	
	

#RUN pip install pystrich

CMD [ "python", "./Project_finalday_tf_idf.py", "UploadToS3", "--local-scheduler", "--awsKey", "AWS key", "--awsSecret","Secret Key" ]