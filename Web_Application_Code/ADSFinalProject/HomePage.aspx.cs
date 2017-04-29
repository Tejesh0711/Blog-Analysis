using Newtonsoft.Json;
using System;
using System.Threading;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ADSFinalProject;
using System.IO;
using Microsoft.VisualBasic.FileIO;


using webhoseio;


using System.Threading.Tasks;

namespace WebApplication2
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Submit(object sender, EventArgs e)
        {

            
            Console.Write("Invoking web services");
            getDataFromWebhose(txtSearchKeyword.Text);


            //ScriptManager.RegisterStartupScript(this, GetType(), "enableData", "enableData();",true);
        }

        public  void  getDataFromWebhose(String searchKeyword)
        {
            WebhoseRequest clientRequest = new WebhoseRequest("cd385b5f-6734-426d-bbe2-0b4d938d46bf");
            WebhoseResponse response = clientRequest.getResponse("aftonbladet");

            //foreach (WebhosePost post in response.posts)
            //{
                //Console.WriteLine (post);
            //}
            //Console.WriteLine();

            //exapmle for query
            WebhoseQuery clientQuery = new WebhoseQuery();

            clientQuery.AddAllTerms(txtSearchKeyword.Text); // what you want to search
            //clientQuery.AddSomeTerms("apple iphone", "samsung", "esny"); // words that may be in the search
            clientQuery.AddLanguages(Languages.english);
            //clientQuery.AddSiteSuffix("com"); // Limit the results to a specific site suffix
            //clientQuery.AddOrganization("apple", "");
            //clientQuery.AddSites ("macnn.com", "appleinsider.com");
                                              //clientQuery.AddOrganization ("apple", "MNM Media");
            clientQuery.ResponseSize = 50;
            //clientQuery.Author = "";
            clientQuery.AddCountries("US"); // filtring by country  - give much less data - To get the full country code list, visit countrycode.org.

            Console.WriteLine("responceWithQuery");
            WebhoseResponse responceWithQuery = clientRequest.getResponse(clientQuery);
            Console.WriteLine(responceWithQuery);

            //Console.ReadKey();

            //Just change NEW_API_KEY to your new API
            //clientRequest.setAPI("NEW_API_KEY");

            WebhoseResponse moreFromResponse = response.getNext();
            Console.WriteLine(moreFromResponse.posts.Count);

            List<Text> blogText = new List<Text>();

            int i = 0;
            foreach(WebhosePost post in moreFromResponse.posts)
            {
                blogText.Add(new Text() { BlobTitle = moreFromResponse.posts[i].title, BlobText = moreFromResponse.posts[i].text, FetchTimestamp = moreFromResponse.posts[i].crawled});
                i++;
            }
            if (IsPostBack)
            {
                repPeople.DataSource = blogText;
                repPeople.DataBind();
            }

            Console.WriteLine(response.posts[5].title);

            //for getting post every 5 minutes
            //			while(true) {
            //				try {
            //					foreach (webhosePost post in response.posts) 
            //					{
            //						//just change the performAction to what you want to do with your posts
            //						//performAction(post);
            //					}
            //					Thread.Sleep(300000);
            //					response = response.getNext();
            //
            //				} catch (ThreadInterruptedException e) {
            //					Console.WriteLine (e.Message);
            //					break;
            //				}
            //			}

            Console.WriteLine("total:" + response.totalResults);
            Console.WriteLine("response" + response.posts.Count);
            txtRevPost.Text = response.posts.Count.ToString();
            //var client = new WebhoseClient(token: "cd385b5f-6734-426d-bbe2-0b4d938d46bf");
            //var output =  client.QueryAsync("filterWebData", new Dictionary<string, string> { { "q", txtSearchKeyword.Text } }).Result;

        }


        protected void calculateIntrestRates(object sender, EventArgs e)
        {
            String uri = null;
            String apiKey = null;
            // Manual clustring
            int manualScore = 0;
        }
            
        public void LoadManualData(object sender, EventArgs e)
        {

            List<Text> revelentBlogText = new List<Text>();
            List<Text> nonRevelentBlogText = new List<Text>();
            float score;
            float position;
            int relativeCount = 0;
            int nonRelativeCount = 0;

            string path = AppDomain.CurrentDomain.BaseDirectory + @"\testfile1.csv";
            using (TextFieldParser parser = new TextFieldParser(path))
            {
                parser.TextFieldType = FieldType.Delimited;
                parser.SetDelimiters(",");
                while (!parser.EndOfData)
                {
                    //Processing row
                    string[] fields = parser.ReadFields();
                    //foreach (string field in fields)
                    //{
                    //if( field)
                    //title = 
                    //}
                    try
                    {
                        score = float.Parse(fields[36]);
                        position = float.Parse(fields[37]);
                    }
                    catch (FormatException i)
                    {
                        continue;
                    }
                    int rev = Convert.ToInt32(InvokeClassification(score, position));
                    if (rev == 1)
                    {
                        relativeCount++;
                        revelentBlogText.Add(new Text() { BlobTitle = fields[3], BlobText = fields[31], FetchTimestamp = fields[14] });
                    } else
                    {
                        nonRelativeCount++;
                        nonRevelentBlogText.Add(new Text() { BlobTitle = fields[3], BlobText = fields[31], FetchTimestamp = fields[14] });
                    }
                }
                txtRevPost.Text = relativeCount.ToString();
                txtNonRevPost.Text = nonRelativeCount.ToString();
                if (IsPostBack)
                {
                    revelentBlogRepeater.DataSource = revelentBlogText;
                    revelentBlogRepeater.DataBind();

                    nonReleventBlogRepeater.DataSource = nonRevelentBlogText;
                    nonReleventBlogRepeater.DataBind();
                }
                
            }
        }

        protected void loadClusters(object sender, EventArgs e)
        {
            
        }

        protected string InvokeClassification(float score, float position)
        {
            Console.Write("Forming Jason Object");
            using (var client = new HttpClient())
            {
                var scoreRequest = new
                {
                    Inputs = new Dictionary<string, List<Dictionary<string, string>>>() {
                        {
                            "input1",
                            new List<Dictionary<string, string>>(){new Dictionary<string, string>(){
                                            {
                                                "score", score.ToString()
                                            },
                                            {
                                                "position", position.ToString()
                                            },
                                }
                            }
                        },
                    },
                    GlobalParameters = new Dictionary<string, string>()
                    {
                    }
                };
                Console.Write("Jason object created");
                Console.Write("Connecting to Werb service ======>");
                const string apiKey = "hDVYgxCwFnEElEbbTlRzJZd1NPuGZ2E+33rxLmoAK0jCmQQBeLlct9Ax8uHGZM2W8jOBng/XU4sDKxrTMGp+Ww=="; // Replace this with the API key for the web service
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
                client.BaseAddress = new Uri("https://ussouthcentral.services.azureml.net/workspaces/d4366c2d85fd451da2a1b3cfa21d13e5/services/edc0dee8aaf74a8d9dfc63eed9c21456/execute?api-version=2.0&format=swagger");

                HttpResponseMessage response = client.PostAsJsonAsync("", scoreRequest).Result;
                string output = null;
                if (response.IsSuccessStatusCode)
                {
                    Console.WriteLine("Sending Request");
                    String result = response.Content.ReadAsStringAsync().Result;
                    // JObject responseData = JObject.Parse(result);
                    dynamic jsonData = JsonConvert.DeserializeObject<dynamic>(result);
                    output = jsonData.Results.output1[0]["Scored Labels"];
                    //txtResult.Text = cnic;
                    Console.WriteLine("Result: {0}", result);
                }
                else
                {
                    Console.WriteLine(string.Format("The request failed with status code: {0}", response.StatusCode));
                    // Print the headers - they include the requert ID and the timestamp,
                    // which are useful for debugging the failure
                    Console.WriteLine(response.Headers.ToString());

                    string responseContent = response.Content.ReadAsStringAsync().Result;
                    Console.WriteLine(responseContent);
                }
                return output;
            }
        }



    }
}