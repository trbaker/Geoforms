
<html>
<head>
	<title>EdGIS: GeoForms for Google Drive Forms</title>
<META HTTP-EQUIV="Content-Type" content="text/html; charset=utf-8">
<META NAME="Copyright" content="2008">
<META HTTP-EQUIV="content-language" content="EN">
<META NAME="Rating" content="General">
<META NAME="Keywords" content="EdGIS Geographic Information Systesms GIS education schools higher university">
<META NAME="Abstract" content="Thomas R Baker EdGIS 2015 ">
<META NAME="Title" content="EdGIS : Search for GIS in education">
<META NAME="revisit-after" content="2">
<META NAME="Robots" content="index,follow">
<META NAME="Description" content="Find GIS lessons, data, readings, and materials from a variety of GIS in education websites.  Geographic Information Systems">
<link rel="stylesheet" type="text/css" href="/includes/site.css">
</head>
<body>
<cfinclude template="/account_info.cfm" />

<table width="500" cellpadding="0" cellspacing="0"><tr><td>
<a href="http://www.edgis.org"><img alt="EdGIS : A GIS in education search tool" border=0 src="/edgis/sm_edgis_searchTool.jpg"></a>
</td>
<td>
<form action="/edgis/results.html" id="cse-search-box">
  <div>
    <input type="hidden" name="cx" value="000824870972198775592:kyguqygiaf0" />
    <input type="hidden" name="cof" value="FORID:9" />
    <input type="text" name="q" size="25" />
    <input type="submit" name="sa" value="Search" />
  </div>
</form>
<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=cse-search-box&lang=en"></script>

</td></td>
</table>

	<table cellpadding="0" cellspacing="0" width="100%">
	<tr><td width="120">&nbsp;</td>
	<td>
	<font size="+1" face="Arial, Helvetica, sans-serif" color="#B6B6B6">
	GeoForms for Google Drive Forms</font>


<cfif isDefined("GDurl") AND len(GDurl) GTE 22 AND isDefined("sbForm")>
<!---- error checking ----->

<cfif GDurl DOES NOT contain "://docs.google.com/">
  <br />
  Bad request. Error logged.
<cfmail to="" subject="GeoFrom Tool: Bad URL" from="" type="HTML">
  	Bad URL submitted: 
<a href="#GDurl#" target="new">#GDURL#</a>
</cfmail>

<cfabort>
</cfif>

<!----- --------------------->

<cfoutput>
<cfhttp url="#FORM.GDURL#" 
useragent="Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/533.7 (KHTML, like Gecko) Chrome/5.0.391.0 Safari/533.7"
method="get"
>

<cfset sTempString = cfhttp.filecontent>
<cfif cfhttp.filecontent is "Connection Failure">
<br /><br />
SYSTEM ERROR: There was a failure connecting to Google.  This is typically due to Google
blocking, testing, or revising Google Drive. Please try again in a day.  Our apologies.

<! error reporting  ----->
<cfmail to="" 
	from="" 
	subject="GeoForm tool: Connection Failure" 
	server="mail.edgis.org" 
	>
The GeoForms tools has encountered a general failure connecting to Google.
</cfmail>
<cfabort>
</cfif>


<!---- process document ---------------------------------------------------->
<cfset sStartTag = FindNoCase("Latitude", sTempString) +8>
 <cfset smidTag = FindNoCase("id=""", sTempString,sStartTag) +4> 
  <cfset sendTag = FindNoCase(""" ", sTempString,smidTag)> 
 <cfset endTemp = sendTag - smidTag>
 <cfset latid = MID(sTempString,smidTag,endTemp)> 


<cfset sStartTag  = FindNoCase("Longitude", sTempString) +9> 
 <cfset smidTag = FindNoCase("id=""", sTempString,sStartTag) +4>
 <cfset sendTag = FindNoCase(""" ", sTempString,smidTag)> 
 <cfset endTemp = sendTag - smidTag>
 <cfset longid = MID(sTempString,smidTag,endTemp)> 

<cfset sStartTag   = FindNoCase("Accuracy", sTempString) +8>
 <cfset smidTag = FindNoCase("id=""", sTempString,sStartTag) +4>
 <cfset sendTag = FindNoCase(""" ", sTempString,smidTag)> 
 <cfset endTemp = sendTag - smidTag>
 <cfset accid = MID(sTempString,smidTag,endTemp)> 
 
 
 <!---- ************************************************************************** ---->
 <!---- swap out link href url to clean up data presentation issues triggered by G validation ------>
 
 <cfset StartTag = FindNoCase("link href", sTempString) +11>
  <cfset endTag = FindNoCase("'", sTempString,startTag)>
 <cfset endTemp = endTag - startTag>
 <cfset linkid = MID(sTempString,startTag,endTemp)> 
 <cfset newURL = "https://docs.google.com/static/forms/client/css/2757023664-formview_ltr.css">
<cfset sTempString = ReplaceNoCase(sTempString,linkid,newURL)>

 <!---- ************************************************************************** ---->
 
 
<br /><font size="-2">System reporting: #latid#, #longid#, #accid#</font>
</cfoutput>

<!---- insert javascript block ---------------------------------------->
<cfset sStartTag  = FindNoCase("<input type=""submit"" name=""submit", sTempString)>

<cfsavecontent variable="geojs">
<script language="javascript" type="text/javascript">
	function getLocation() {
	// Get location no more than 10 minutes old. 600000 ms = 10 minutes.
	navigator.geolocation.getCurrentPosition(showLocation, showError, {enableHighAccuracy:true,maximumAge:300000});
			}
 
			function showError(error) {
				alert(error.code + ' ' + error.message);
			}
 
 <cfoutput>
			function showLocation(position) {
				document.getElementById('#latid#').value = position.coords.latitude;
				document.getElementById('#longid#').value = position.coords.longitude;
				document.getElementById('#accid#').value = position.coords.accuracy;
				}	
</cfoutput>
		</script>

<script language="javascript" type="text/javascript">	
		document.write('<br /><input type="button" onclick="getLocation()" value="Show Location Information" /><br />');
		</script>
</cfsavecontent>

<cfset sTempString = Insert("#geojs#",sTempString,sStartTag-1)>

<!---- write out the HTML document ----------------------------------------------->

	<cfoutput>
    <cffile action="read" 
	file="\geoforms\tracker.txt" variable="tracker">
    
    <cfset newtracker = #tracker# +1>
    <cfset a = randrange(10,250)>
    
    <cfset newtrackerfilename = "#a#" & "#newtracker#" & ".html">
 
  
    <cffile action="write" nameconflict="makeunique" output="#sTempString#" 
    file="C:\" />
    
    <cffile action="write" output="#newtracker#" nameconflict="overwrite" 
	file="C:\">


    </cfoutput>

<!---- ------------------------------------------------------------------------------>


<P style="width:300px;">
<cfoutput>
<br />
Please record your URL: <br />
<a href="http://edgis.org/geoforms/#newtrackerfilename#" target="new">http://edgis.org/geoforms/#newtrackerfilename#</a>
</cfoutput>
</p>





<cfmail to="" 
	from="" 
	subject="GeoForm Tool: A New FOrm Created" 
	server="" 
	username=""  
	>
A new Geoform was created at:
<a href="http://edgis.org/geoforms/#newtrackerfilename#" target="new">http://edgis.org/geoforms/#newtrackerfilename#</a>
</cfmail>


<cfelse>
<blockquote id="two">
<font size="+2">T</font><font size="-1">his application adds Javascript to your Google Drive Form.  The modified form will send the data to your Google Drive Spreadsheet and can then be <a href="http://blogs.esri.com/esri/arcgis/2012/02/21/using-google-docs-in-your-arcgis-online-maps/" target="_new">mapped nicely with the ArcGIS.com map viewer</a>.


<br><BR>

Documentation:<br />
&nbsp;&nbsp; <a href="https://dl.dropbox.com/u/4478322/EdGIS/EdGIS_GeoForm_HowTo.pdf">Short Instructions</a> (PDF)<br />
</p>

</blockquote>

<P style="width:300px;">
<em>Updated for new Google Drive Forms! February 2013</em>
</p>
<P style="width:300px;">
This experimental tool adds latitude, longitude, and accuracy mobile-aware fields to a Google Drive <b>Form</b>.  The resulting
"GeoForm" has been tested on iOS and Android devices that are location aware.  This tool is
strictly for use by those in <b>education</b>.  
</p>
<P style="width:300px;">
I will hold your GeoForm for 30 days before auto-deleting it.  I do
not record any data passed between your GeoForm and your Google Drive Spreadsheet.  I recommend that you
copy your GeoForm to your own server or Dropbox public folder for hosting purposes.
<br /><br />
GeoForm data on edgis.org is not submitted securely.  Do not use this form for sensitive information or student personal data.
An example geoform, asking the question "what do you call a carbonated beverage?" 
is <a href="" target="new">available for testing</a>.
</p>

<P>
Your Google Drive <b>Form</b> should have these fields:
<ul>
<LI>Field: Latitude  (text, not required)
<LI>Field: Longitude (text, not required)
<LI>Field: Accuracy  (text, not required)
<LI>and any data students should collect</LI>
</ul>
</p>

<P>
<hr size=1 width=300 align="left" noshade><br />
<cfform action="geoforms.cfm" method="post">
Paste the URL to your Google Drive "Live Form":<br />
<cfinput type="text" name="GDurl" value="" size=35 maxlenght="300" required="yes" message="URL required.">
<cfinput type="submit" name="sbForm" value="Submit My Form">
</cfform>
<br />
<hr size=1 align="left" width=300 noshade>

</cfif>





<br /><br /><br />
	</td></tr></table>

<cfinclude template="/sdm/virtual/footer.cfm"/ >


