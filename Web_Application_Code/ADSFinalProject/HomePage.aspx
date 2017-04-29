<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="WebApplication2.WebForm3" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Live Blog Analysis : ADS</title>
	<!-- BOOTSTRAP STYLES-->
    <link href="assets/css/bootstrap.css" rel="stylesheet" />
     <!-- FONTAWESOME STYLES-->
    <link href="assets/css/font-awesome.css" rel="stylesheet" />
        <!-- CUSTOM STYLES-->
    <link href="assets/css/custom.css" rel="stylesheet" />
     <!-- GOOGLE FONTS-->
   <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css' />
</head>
    <script type="text/javascript">
    function enableData() {
        alert("Congratss!!! You are elegible to get a loan");
        document.getElementById("div_row1").style.display= 'block';
        //document.getElementById("txtSubGrade").style.visibility = 'block';
    }
</script>
<body>
    
    <div>
        <div id="wrapper">
        <nav class="navbar navbar-default navbar-cls-top " role="navigation" style="margin-bottom: 0">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".sidebar-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href=#>Live Blog Analysis</a> 
            </div>
  <div style="color: white;
padding: 15px 50px 5px 50px;
float: right;
font-size: 16px;">  &nbsp;  </div>
        </nav>   
           <!-- /. NAV TOP  -->
                <nav class="navbar-default navbar-side" role="navigation">
            <div class="sidebar-collapse">
                <ul class="nav" id="main-menu">
				<li class="text-center">
                    <img src="assets/img/find_user.png" class="user-image img-responsive"/>
					</li>
				
					
                    <li>
                        <a  href="HomePage.aspx"><i class="fa fa-dashboard fa-3x"></i> Dashboard</a>
                    </li>
                </ul>
               
            </div>
            
        </nav>  
        <!-- /. NAV SIDE  -->
        <div id="page-wrapper" >
            <div id="page-inner">
                <div class="row">
                    <div class="col-md-12">
                     <h2>Live Blog Analysis</h2>   
                        <h5>Welcome , Love to see you back. </h5>
                       
                    </div>
                </div>
                 <!-- /. ROW  -->
                 <hr />
                <form id="form1" runat="server" role="form">
               <div id="div_row1" class="row" >
               <div class="col-md-12">
                    <!-- Form Elements -->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Search Form
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h3>Search some topic</h3>
                                    
                                        
                                        <div class="form-group">
                                            <label>Search Keyword</label>
                                            <asp:TextBox ID="txtSearchKeyword" runat="server" class="form-control"/>
                                        </div>
                                        
                                        <asp:Button ID="Button1" runat="server" Text="Search the web" OnClick ="Submit" class="btn btn-primary"/>
                                        <button type="reset" class="btn btn-default">Reset</button>
                                        <asp:Button ID="ManuaData" runat="server" Text="Load Data" OnClick ="LoadManualData" class="btn btn-default"/>

                                    
                             
                                 
                                </div>
                            </div>
                        </div>
                    </div>
                     <!-- End Form Elements -->
                </div>
            </div>
                <!-- /. ROW  -->
            <div id ="div_row2" class="row" >
                <div class="col-md-12">
                    <!-- Form Elements -->
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h3>Classify Posts</h3>


                                    <div class="form-group">
                                        <label>Relevant post count</label>
                                        <asp:TextBox ID="txtRevPost" runat="server" class="form-control"/>
                                    </div>
                                    <div class="form-group input-group">
                                        <span class="input-group-addon">$</span>
                                        <asp:Button ID="btnCluster" runat="server" Text="Search the web" OnClick ="loadClusters" class="btn btn-primary"/>
                                        <span class="input-group-addon">.00</span>
                                    </div>
                                    <div class="form-group">
                                        <label>Non Relevant post count</label>
                                        <asp:TextBox ID="txtNonRevPost" runat="server" class="form-control"/>
                                    </div>      
                                   
                                     <div class="form-group">
                                        <asp:Repeater ID="repPeople" runat="server">
                                            <ItemTemplate>
                                                <table>
                                                    <thead> <tr> <th>Blog Title</th> <th >Blog Text</th> <th>Fetch Timestamp</th>  </tr></thead>
                                                    <tr>
                                                        <td><asp:TextBox ID="txtName" runat="server" Text='<%# Eval("BlobTitle") %>' /></td>
                                                        <td><asp:TextBox ID="txtLastName" runat="server" Text='<%# Eval("BlobText") %>' /></td>
                                                        <td><asp:TextBox ID="txtAge" runat="server" Text='<%# Eval("FetchTimestamp") %>' /></td</tr>     
                                                </table>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                    <div class="form-group">
                                        <label>Relevant posts</label>
                                    </div>  
                                    <div class="form-group">
                                        <asp:Repeater ID="revelentBlogRepeater" runat="server">
                                            <ItemTemplate>
                                                <table>
                                                    <thead> <tr> <th>Blog Title</th> <th >Blog Text</th> <th>Fetch Timestamp</th>  </tr></thead>
                                                    <tr>
                                                        <td><asp:TextBox ID="txtName" runat="server" Text='<%# Eval("BlobTitle") %>' /></td>
                                                        <td><asp:TextBox ID="txtLastName" runat="server" Text='<%# Eval("BlobText") %>' /></td>
                                                        <td><asp:TextBox ID="txtAge" runat="server" Text='<%# Eval("FetchTimestamp") %>' /></td</tr>     
                                                </table>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>

                                    <div class="form-group">
                                        <div class="form-group">
                                            <label>Non Relevant posts</label>
                                        </div>  
                                            <asp:Repeater ID="nonReleventBlogRepeater" runat="server">
                                            <ItemTemplate>
                                                <table>
                                                    <thead> <tr> <th>Blog Title</th> <th >Blog Text</th> <th>Fetch Timestamp</th>  </tr></thead>
                                                    <tr>
                                                        <td><asp:TextBox ID="txtName" runat="server" Text='<%# Eval("BlobTitle") %>' /></td>
                                                        <td><asp:TextBox ID="txtLastName" runat="server" Text='<%# Eval("BlobText") %>' /></td>
                                                        <td><asp:TextBox ID="txtAge" runat="server" Text='<%# Eval("FetchTimestamp") %>' /></td</tr>     
                                                </table>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>                                                                                
    </div>
                                
                            </div>
                        </div>
                    </div>
                     <!-- End Form Elements -->
                </div>
            </div>

                <!-- /. ROW  -->
               <div id="div_row_output" class="row" >
               <div class="col-md-12">
                    <!-- Form Elements -->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Categories of blogs
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h3>Clusters</h3>

                                    <div class="form-group">
                                        <label>Entertainment</label>
                                        <asp:TextBox ID="txtEntertainmentOutput" runat="server" class="form-control" />
                                    </div>

                                    <div class="form-group">
                                        <label>Finance</label>
                                        <asp:TextBox ID="txtFinanceOutput" runat="server" class="form-control" />
                                    </div>

                                    <div class="form-group">
                                        <label>Hotel</label>
                                        <asp:TextBox ID="txtHotelOutput" runat="server" class="form-control" />
                                    </div>

                                    <div class="form-group">
                                        <label>Movie</label>
                                        <asp:TextBox ID="txtMovieOutput" runat="server" class="form-control" />
                                    </div>

                                    <div class="form-group">
                                        <label>Political</label>
                                        <asp:TextBox ID="txtPoliticalOutput" runat="server" class="form-control" />
                                    </div>

                                    <div class="form-group">
                                        <label>Sports</label>
                                        <asp:TextBox ID="txtSportsOutput" runat="server" class="form-control" />
                                    </div>

                                    <div class="form-group">
                                        <label>Technology</label>
                                        <asp:TextBox ID="txtTechnologyOutput" runat="server" class="form-control" />
                                    </div>

                                    <div class="form-group">
                                        <label>Travel</label>
                                        <asp:TextBox ID="txtTravelOutput" runat="server" class="form-control" />
                                    </div>

                                    <div class="form-group">
                                        <label>World</label>
                                        <asp:TextBox ID="txtWorldOutput" runat="server" class="form-control" />
                                    </div>

                                    <div class="form-group">
                                        <label>Other</label>
                                        <asp:TextBox ID="txtOtherOutput" runat="server" class="form-control" />
                                    </div>
                                  
                                 
                                </div>
                            </div>
                        </div>
                    </div>
                     <!-- End Form Elements -->
                </div>
            </div>
                <!-- /. ROW  -->



                 </form>
    </div>
             <!-- /. PAGE INNER  -->
            </div>
         <!-- /. PAGE WRAPPER  -->
        </div>
     <!-- /. WRAPPER  -->
    <!-- SCRIPTS -AT THE BOTOM TO REDUCE THE LOAD TIME-->
    <!-- JQUERY SCRIPTS -->
    <script src="assets/js/jquery-1.10.2.js"></script>
      <!-- BOOTSTRAP SCRIPTS -->
    <script src="assets/js/bootstrap.min.js"></script>
    <!-- METISMENU SCRIPTS -->
    <script src="assets/js/jquery.metisMenu.js"></script>
      <!-- CUSTOM SCRIPTS -->
    <script src="assets/js/custom.js"></script>
 
    </div>
</body>
</html>
