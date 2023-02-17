// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "trix"
import "@rails/actiontext"

//= require select2

$(document).ready(function(){
    // Turn on js-selectable class so that it becomes SELCT 2 tag
    $('.js-searchable').select2({
      allowClear: true,
      width: 200
      // If you are using Bootstrap, please add　`theme: "bootstrap"` too.
    });
  })

  function myFunction() {
    var x = document.getElementById("myDIV");
    if (x.style.display === "none") {
      x.style.display = "block";
    } else {
      x.style.display = "none";
    }
  }
 