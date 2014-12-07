function CreateTable(db,query)
	{
     db.transaction(function (tx) {  
     tx.executeSql(query);
    });

	}
	
    function insertRecord(db,query) 
	{
      db.transaction(function(tx) 
	  {
      tx.executeSql(query);

      });

     }

 function ExecuteQuery(db,query) 
	{
      alert("hi");
	  
	  db.transaction(function(tx) 
	  {
      tx.executeSql(query);
      
      });

     }

	 function OnlineStatus(div,mode)
	 {
      var online = window.navigator.onLine;
      if(online && mode=="true")
	  $("#"+div).html(" <img src='images/user-online.png' />");
	  else
	 $("#"+div).html("  <img src='images/user-offline.png' />");
     }

function RecordSet(flag)
 {
  if(flag==0)
  page--;
  else
  page++;

  listUI("datalist","All",page);
 }
 
 function getLogin()
   {
   
  
   
        var login = $('#Lusername').val();
        var pass = $('#Lpassword').val();
   
          $.ajax({
          url: "http://socialnama.com/mobicrm/login.php",
          dataType: 'jsonp',
          jsonp: 'jsoncallback',
          timeout: 5000,
          data:{login:login,password:pass},
          success: function(json, status)
          {
            
            
            if(json.result==1)
            {
            window.localStorage.setItem("user", login);
			window.localStorage.setItem("pass", pass);
            window.location.href="home.html";
            }
            else
            $("#error").html("Login Failed");       
         }
       });
        
    }

	 function changePage(div,name,email,title,phone)
 {
     $("#"+div).html("");
	 var html="<div class=\"ui-grid-a\"><div class=\"ui-block-a\" style=\"height:30px\"><strong>Name </strong></div><div class=\"ui-block-b\">"+name+"</div></div><div class=\"ui-grid-a\"><div class=\"ui-block-a\" style=\"height:30px\"><strong>Title </strong></div><div class=\"ui-block-b\">"+title+"</div></div><div class=\"ui-grid-a\"><div class=\"ui-block-a\"><strong>Phone </strong></div><div class=\"ui-block-b\"><a href='tel:"+phone+"' data-role='button'>"+phone+"</a></div></div><div class=\"ui-grid-a\"><div class=\"ui-block-a\"><strong>Email </strong></div><div class=\"ui-block-b\"><a href='mailto:"+email+"' data-role='button'>"+email+"</a></div></div><div class=\"ui-grid-a\"><div class=\"ui-block-a\"><a href='#' data-role=\"button\" data-icon=\"gear\">Edit</a></div><div class=\"ui-block-b\"><a href='' data-role='button' data-icon=\"add\" >Convert Lead</a></div>";
 
     $("#"+div).append(html);
	 $("#"+div).trigger('refresh');
	 $("#"+div).trigger('create');
 
 }
 function changePageLead(div,name,email,title,phone,mobile,department,status)
 {
     $("#"+div).html("");
	 var html="<div class=\"ui-grid-a\"><div class=\"ui-block-a\" style=\"height:30px\"><strong>Name </strong></div><div class=\"ui-block-b\">"+name+"</div></div><div class=\"ui-grid-a\"><div class=\"ui-block-a\" style=\"height:30px\"><strong>Title </strong></div><div class=\"ui-block-b\">"+title+"</div></div><div class=\"ui-grid-a\"><div class=\"ui-block-a\" style=\"height:30px\"><strong>Department </strong></div><div class=\"ui-block-b\">"+department+"</div></div><div class=\"ui-grid-a\"><div class=\"ui-block-a\" style=\"height:30px\"><strong>Status </strong></div><div class=\"ui-block-b\">"+status+"</div></div><div class=\"ui-grid-a\"><div class=\"ui-block-a\"><strong>Phone </strong></div><div class=\"ui-block-b\"><a href='tel:"+phone+"' data-role='button'>"+phone+"</a></div></div><div class=\"ui-grid-a\"><div class=\"ui-block-a\" style=\"height:30px\"><strong>Mobile </strong></div><div class=\"ui-block-b\"><a href='tel:"+mobile+"' data-role='button'>"+mobile+"</a></div></div><div class=\"ui-grid-a\"><div class=\"ui-block-a\"><strong>Email </strong></div><div class=\"ui-block-b\"><a href='mailto:"+email+"' data-role='button'>"+email+"</a></div></div><div class=\"ui-grid-a\"><div class=\"ui-block-a\"><a href='#' data-role=\"button\" data-icon=\"gear\">Edit</a></div><div class=\"ui-block-b\"><a href='' data-role='button' data-icon=\"add\" >Convert Lead</a></div>";
 
     $("#"+div).append(html);
	 $("#"+div).trigger('refresh');
	 $("#"+div).trigger('create');
 
 }
		