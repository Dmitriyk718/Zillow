<%-- 
    Document   : Zillow
    Created on : Nov 17, 2015, 8:42:07 AM
    Author     : Class
--%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.XML"%>
<%@page import="java.io.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Results</title>
    </head>
    <body>
        <%@ page import="org.netbeans.saas.*, org.netbeans.saas.zillow.*" %>

        <%
            int id, estValue = 0;
            String charResult, imgUrl = "";
            String estResults, estDate = "";
            String a = request.getParameter("addressTxtBx");
            String z = request.getParameter("cszTxtBx");
            
            try {
                
                String outputcontent = "";

                RestResponse result = ZillowRealEstateService.getSearchResults(a, z);
                if (result.getResponseCode() == 200) {
                    outputcontent = result.getDataAsString();
                } else {
                    out.println("Not Working");
                }

                JSONObject json1 = XML.toJSONObject(outputcontent);
                id = json1.getJSONObject("SearchResults:searchresults")
                        .getJSONObject("response")
                        .getJSONObject("results")
                        .getJSONObject("result")
                        .getInt("zpid");
                estDate = json1.getJSONObject("SearchResults:searchresults")
                        .getJSONObject("response")
                        .getJSONObject("results")
                        .getJSONObject("result")
                        .getJSONObject("zestimate")
                        .getString("last-updated");
                estValue = json1.getJSONObject("SearchResults:searchresults")
                        .getJSONObject("response")
                        .getJSONObject("results")
                        .getJSONObject("result")
                        .getJSONObject("zestimate")
                        .getJSONObject("amount")
                        .getInt("content");

                 String zpid = String.valueOf(id);
                 String unittype = "dollar";
                 String width = "300";
                 String height = "200";
                 String chartduration = "1year";

                 RestResponse result1 = ZillowRealEstateService.getChart(zpid, unittype, width, height, chartduration);
                 if (result1.getDataAsObject(zillow.realestateservice.chart.Chart.class) instanceof zillow.realestateservice.chart.Chart) {
                 zillow.realestateservice.chart.Chart result1Obj = result1.getDataAsObject(zillow.realestateservice.chart.Chart.class);  
                 }
                
                 charResult = result1.getDataAsString();
                
                 JSONObject json2 = XML.toJSONObject(charResult);
                 imgUrl = json2.getJSONObject("Chart:chart")
                 .getJSONObject("response")
                 .getString("url");

                
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            
            out.println("The estimated selling price for <br/> Address: " +a+" "+z+ "<br/> is = $" +estValue+ " as of "+estDate );
            out.println("<br/> <img src="+imgUrl+">");
        %>
        
    </body>
</html>
