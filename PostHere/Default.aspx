<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PostHere.Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="Script/jquery-1.8.0.js"></script>
    <script type="text/javascript" src="Script/json2.js"></script>
</head>
    <style>
        #divText {
            width:800px;
        }
        #txtInput {
            width: 800px;
        }
        #divInputBar {
            background-color:#000;
            vertical-align:central;
            text-align:center;
            height:50px;
            
        }
        .incomingtext {
            color:#ffd800;
        }
        .outgoingtext {
            color: #f00;
        }
        body {
            background-color:#000;
        }

        input {
            border-radius:5px;
            border-style:groove;
            border-color:#ffd800;
            box-shadow:initial;
        }
        button {
            border-radius: 5px;
            border-style: groove;
            border-color: #ffd800;
            box-shadow: initial;
        }
            
        #txtLastPostTimeStamp {
            visibility:hidden;
        }
    </style>
    <script>
        $(document).ready(function () {
            reset();
            //$('#btnSend').click(function submit() { var post = GetPost(); SendText(post); });
            $('#txtInput').focus();
            pollChat();
           
        });

        function reset() {
            $('#divText').height(window.innerHeight - 50);
            $('#divText').width(window.innerWidth-25);
            $('#divText').scrollTop($('#divText').get(0).scrollHeight);

        }
        function sendForm()
        {
            if ($('#txtScreenname').val() == ""){
                alert("Enter a screen name");
                exit;
                }
            var post = GetPost();
            if (post != "")
                SendText(post);
            $('#txtInput').val("");
        }

        function SendText(post) {
            var DTO = { 'serPost': post };  
            $.ajax({
                
                type:"post",
                url: "Default.aspx/WriteLine",
                content: "json",
                //data: "{'ScreenName': 'blue', 'TimeStamp', '" + $.now().toString() + "', 'PostText': '" + $('#txtInput').val().toString() + "' }",
                data: JSON.stringify(DTO),
                async: false,
                cache: false,
                contentType: "application/json; charset=utf-8",
                success: function (strText) {
                    var parsed = $.parseJSON(strText.d);
                    GetText(parsed);
                }
            })
        }

        function GetText(jsObjs) {
            $.each(jsObjs, function (i, jsObj) {
                if (jsObj.ScreenName == $('#txtScreenname').val()) {
                    $('#divText').append('<span class="outgoingtext">' + jsObj.ScreenName + ' - ' + jsObj.PostText + '</span><br/>')
                }
                else {
                    $('#divText').append('<span  class="incomingtext">' + jsObj.ScreenName + ' - ' + jsObj.PostText + '</span><br/>')
                }
                $('#txtLastPostTimeStamp').val(jsObj.TimeStamp.toString());
            })
            reset();
        }
        function pollChat() {
        var lastTimeStamp = $('#txtLastPostTimeStamp').val();
        $.ajax({
            url: "Default.aspx/GetChatText",
            type: "post",
            content: "json",
            data: "{'timeStamp': '" + lastTimeStamp.toString() + "' }",
            //data: { lastTimeStamp: lastTimeStamp.toString() },
            async: true,
            cache: false,
            contentType: "application/json; charset=utf-8",
            success: function (strText) {
                var parsed = $.parseJSON(strText.d);
                GetText(parsed);
                setTimeout(function () { pollChat(); }, 1000);
            },
            error: function(){setTimeout(function () { pollChat(); }, 10000);}
        })
        }

        function DoAjaxStuff() {
            $.ajax({
                type:"post",
                url:"Default.aspx/GetChatText",
                data:"{}",
                async:false,
                cache:false,
                contentType:"application/json; charset=utf-8",
                success:function(msg){
                    alert(msg.d);
                }
            })
        }
        function GetPost() {
            var post = {};
            post.ScreenName = $('#txtScreenname').val();
            post.TimeStamp = $.now();
            post.PostText = $('#txtInput').val();
            post.LastPostTimeStamp = $('#txtLastPostTimeStamp').val();
            
            return post;

            //return (strText == "") ? null : { ScreenName: strScreenName, TimeStamp: dtTimeStamp, PostText: strText };
        }
    </script>
    
<body>
    <form id="form1" action="javascript:sendForm()">
        <div id="divText" style="overflow-x:auto;"></div>
        <div id="divInputBar">
            <input type="text"  name="name" value="" id="txtScreenname"/>
            <input type="text" name="name" value=" " id="txtInput" autocomplete="off"/>
            <%--<input type="button" name="name" value="Send" id="btnSend" onclick="sendForm()"/>--%>
            <button type="submit" value="submit" title="Send">Send</button>
            <input type="text" name="lastpost" value="0" id="txtLastPostTimeStamp"/>
        <%--<input type="button" name="name" value="Send" id="Button1"/>--%>
    </div>
    </form>
</body>
</html>
