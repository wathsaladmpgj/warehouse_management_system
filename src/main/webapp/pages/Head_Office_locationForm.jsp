<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>
<html>
<head>
    <title>Location Form</title>
    <script>
        function suggestLocations() {
            const query = document.getElementById("location").value;
            if (query.length === 0) {
                document.getElementById("suggestions").innerHTML = "";
                return;
            }
            const xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    document.getElementById("suggestions").innerHTML = xhr.responseText;
                }
            };
            xhr.open("GET", "LocationSuggestionServlet?query=" + query, true);
            xhr.send();
        }

        function fillSuggestion(name) {
            document.getElementById("location").value = name;
            document.getElementById("suggestions").innerHTML = "";
        }
    </script>
</head>
<body>
    <form action="${pageContext.request.contextPath}/InsertLocationServlet" method="post">
        <label>Location:</label>
        <input type="text" id="location" name="location" onkeyup="suggestLocations()" autocomplete="on">
        <div id="suggestions" style="border:1px solid #ccc;"></div>

        <label>Postal Code:</label>
        <input type="text" name="postal_code">

        <input type="submit" value="Submit">
    </form>
</body>
</html>
