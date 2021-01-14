
$(document).ready(function() {

  // spam protection for mails
  $('span.madress').each(function(i) {
      var text = $(this).text();
      var address = text.replace(" [at] ", "@");
      $(this).after('<a href="mailto:'+address+'">'+ address +'</a>')
      $(this).remove();
  });

  // activate empty search on start page
  $("#project-searchMainPage").submit(function (evt) {
    $(this).find(":input").filter(function () {
          return !this.value;
      }).attr("disabled", true);
    return true;
  });

  // replace placeholder USERNAME with username
  var userID = $("#currentUser strong").html();
  var newHref = 'https://reposis-test.gbv.de/kartdok/servlets/solr/select?q=createdby:' + userID + '&fq=objectType:mods';
  $("a[href='https://reposis-test.gbv.de/kartdok/servlets/solr/select?q=createdby:USERNAME']").attr('href', newHref);

  // prevent dropdown from leaving visible page area
  $(".language-menu").addClass('dropdown-menu-right');

  // hide openAIRE in forms intially
  if ( localStorage.getItem('open_aire_options_are_visible') === "false" ){
    $('#open-aire_box').css('display', 'none');
  }

  // toggle openAIRE in forms on-click 
  $("#open-aire_trigger_checkbox").click(function(){
    toggleOAOptions();
  });

});


function toggleOAOptions() {
  var duration = 500;
  if ( $('#open-aire_box').is(':visible') ) {
    $('#open-aire_trigger').removeClass('glyphicon-check');
    $('#open-aire_trigger').addClass('glyphicon-unchecked');
    $('#open-aire_box').fadeOut( duration );
    localStorage.setItem("open_aire_options_are_visible", false);
  } else {
    $('#open-aire_trigger').removeClass('glyphicon-unchecked');
    $('#open-aire_trigger').addClass('glyphicon-check');
    $('#open-aire_box').fadeIn( duration );
    localStorage.setItem("open_aire_options_are_visible", true);
  }
}