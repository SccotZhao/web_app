**Deployment of The  Application**
-----------------
Basic introduction
------------------
* We use the copy queries in SQL to load the data into our database. Here is an example:

```sql
COPY PEOPLE FROM '/home/zhiyong_zhao001/people.csv' with csv header;
```
We stored all the data in separates csv files. The user needs to change the corresponding path of the files. And if one wants to change the name of the file, the corresponding path also needs to be changed.

* We use the Flask API in Python to deploy the web application. There are 3 parts in the major Python files:
    *  the model, which is used to connect the corresponding table in our "bills" database. 
    * The config, which is the configurations of the model. The user needs to change the path to corretly deploy the model. The user needs to change the directories in the config
    
    ```Python
    SQLALCHEMY_DATABASE_URI = 'postgresql://zhiyong_zhao001:dbpasswd@localhost/bills'
    ```
    * The app, which is the place to fetch the user input , to connect the database, to execute the queries for each search, to pass the result as varaibles to Javascript and  to render the HTML file.
* The HTML templates
  * The "layout.html" is the entrance of the project. In this file, we also specify some other metadata, such as CSS, Javascript, the location of images, etc.
  *  The "index.html" is the home page of the web, which shows the background information of the website
  *  The "politician.html" specifies the members in our database. Users can search people and related information
  *  The "bill.html" is used to search for bills
  *  The "relation.html" is used to seach the overview of the bills
  *  The "contact.html" is used as a helping page.
  * The "message" and the "no-message" are used to control the output of queries
*  In the static folder, we include the CSS and javascript files  and some images. Users can change the speed of the silde shows by changing paraemter "speed" in the javascript function:
```javascript
$(document).ready(function() {    
  
  // execute the slideShow, set 4 seconds (4000) for each image
  slideShow(4000);

});

function slideShow(speed) {

  // append an 'li' item to the 'ul' list for displaying the caption
  $('ul.slideshow').append('<li id="slideshow-caption" class="caption"><div class="slideshow-caption-container"><p></p></div></li>');

  // set the opacity of all images to 0
  $('ul.slideshow li').css({opacity: 0.0});
  
  // get the first image and display it
  $('ul.slideshow li:first').css({opacity: 1.0}).addClass('show');
  
  // get the caption of the first image from the 'rel' attribute and display it
  $('#slideshow-caption p').html($('ul.slideshow li.show').find('img').attr('alt'));
    
  // display the caption
  $('#slideshow-caption').css({opacity: 0.6, bottom:0});
  
  // call the gallery function to run the slideshow  
  var timer = setInterval('gallery()',speed);
  
  // pause the slideshow on mouse over
  $('ul.slideshow').hover(
    function () {
      clearInterval(timer); 
    },  
    function () {
      timer = setInterval('gallery()',speed);     
    }
  );  
}

function gallery() {

  //if no images have the show class, grab the first image
  var current = ($('ul.slideshow li.show')?  $('ul.slideshow li.show') : $('#ul.slideshow li:first'));

  // trying to avoid speed issue
  if(current.queue('fx').length == 0) {

    // get the next image, if it reached the end of the slideshow, rotate it back to the first image
    var next = ((current.next().length) ? ((current.next().attr('id') == 'slideshow-caption')? $('ul.slideshow li:first') :current.next()) : $('ul.slideshow li:first'));
      
    // get the next image caption
    var desc = next.find('img').attr('alt');  
  
    // set the fade in effect for the next image, show class has higher z-index
    next.css({opacity: 0.0}).addClass('show').animate({opacity: 1.0}, 1000);
    
    // hide the caption first, and then set and display the caption
    $('#slideshow-caption').slideToggle(300, function () { 
      $('#slideshow-caption p').html(desc); 
      $('#slideshow-caption').slideToggle(500); 
    });   
  
    // hide the current image
    current.animate({opacity: 0.0}, 1000).removeClass('show');

  }
}
```

Users can change the color and speed of the slides of the title by changing the attribute in the layout.html

```html
<style> 
h3 {
    width: 700px;
    height: 50px;
    background-color: red;
    position: relative;
    -webkit-animation-name: example; /* Safari 4.0 - 8.0 */
    -webkit-animation-duration: 4s; /* Safari 4.0 - 8.0 */
    -webkit-animation-iteration-count: infinite; /* Safari 4.0 - 8.0 */
    animation-name: example;
    animation-duration: 4s;
    animation-iteration-count: infinite;
}

/* Safari 4.0 - 8.0 */
@-webkit-keyframes example {
    0%   {background-color:red; left:0px; top:0px;}
    25%  {background-color:brown; left:230px; top:0px;}
    50%  {background-color:blue; left:230px; top:0px;}
    75%  {background-color:green; left:0px; top:0px;}
    100% {background-color:red; left:0px; top:0px;}
}

/* Standard syntax */
@keyframes example {
    0%   {background-color:red; left:0px; top:0px;}
    25%  {background-color:brown; left:230px; top:0px;}
    50%  {background-color:blue; left:230px; top:0px;}
    75%  {background-color:green; left:0px; top:0px;}
    100% {background-color:red; left:0px; top:0px;}
}
```


Deployment
-------------------------------

* The user first creates the database in the command line by running the following shell command
```
dropdb bills; createdb bills; psql bills -af ctable.sql 
```

* Then the user changes the directory
```
cd shared/Flask-Web
```
* Last step is
```
python app.py
```
* Now everything is done. The user can go to the correct webpage. Here The webpage urls are different for google cloud and local VM.