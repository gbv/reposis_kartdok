  // page is fully loaded, including all frames, objects and images
$(window).load(function() {
  // check url for anchor
  if (location.href.indexOf("#") != -1) {
    // get anchor element
    var anchor = $(location.hash);
    var anchorContainer = anchor.parent().parent("fieldset");
    var anchorToggle = anchorContainer.find("legend.mir-fieldset-legend");
    console.log("url contains anchor");
    // when anchor is hidden
    if( !anchorToggle.hasClass("hiddenDetail") ) {
      console.log("anchor block is collapsed");
      // show anchor block
      var trueAnchorToggle = anchorToggle.find(".expand-item");
      trueAnchorToggle.closest("legend").toggleClass("hiddenDetail").next().toggleClass("d-none");
      if( trueAnchorToggle.hasClass("fa-chevron-down") ) {
        trueAnchorToggle.removeClass("fa-chevron-down");
        trueAnchorToggle.addClass("fa-chevron-up");
      }
      else {
        trueAnchorToggle.removeClass("fa-chevron-up");
        trueAnchorToggle.addClass("fa-chevron-down");
      }
      // scroll to anchor
      $('html,body').animate({scrollTop: anchor.offset().top},'slow');
    }
  }
});

// document is loaded and DOM is ready
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
  var localHref = 'http://localhost:18041/kartdok/servlets/solr/select?q=createdby:' + userID + '&fq=objectType:mods';
  $("a[href='http://localhost:18041/kartdok/servlets/solr/select?q=createdby:USERNAME']").attr('href', localHref);
  var testHref = 'https://reposis-test.gbv.de/kartdok/servlets/solr/select?q=createdby:' + userID + '&fq=objectType:mods';
  $("a[href='https://reposis-test.gbv.de/kartdok/servlets/solr/select?q=createdby:USERNAME']").attr('href', testHref);
  var prodHref = 'https://kartdok.staatsbibliothek-berlin.de/servlets/solr/select?q=createdby:' + userID + '&fq=objectType:mods';
  $("a[href='https://kartdok.staatsbibliothek-berlin.de/servlets/solr/select?q=createdby:USERNAME']").attr('href', prodHref);



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

  $(".bc-select").each(function () {
    // setDefault($(this));
     if ($(this).children("option").length > 0) {
         setLabelForClassificationBC($(this));
     }
     else {
         setSelect2BC($(this));
     }
  });

  // expand click behavoir to legend that contains the trigger
  // collapsed legend was clicked
  $("body").on("click", ".mir-fieldset-collapsed", function (event) {
    // if contained trigger was not clicked
    if ( !$(event.target).hasClass('expand-item') ) {
      // simulate click on trigger
      $(event.target).find('.expand-item').click();
    }
  });

});

// TODO: Remove once we implement a better solution to hide genre types in pull down menu
$( document ).ajaxComplete(function() {
  // remove kartdok_collection as option from publish/index.xml
  $("select#genre option[value='kartdok_collection']").remove();
});

// TODO: Parameterize the select function in MIR (type-ahead)
function setLabelForClassificationBC(parent) {
  $.ajax({
      url: webApplicationBaseURL + 'servlets/solr/select',
      data: {
              q: optionsToQuery(parent),
              fq: 'classification:kartdok_bc',
              wt: 'json',
              core: 'classification'
      },
      dataType: 'json'
  }).done(function(data) {
      $.each(data.response.docs, function (_i, cat) {
          let text = cat['label.' + $("html").attr("lang")][0];
          if (text === undefined) {
              text = cat['label.en'][0]
          }
          getOptionWithValBC(parent, cat.category).html(text);
      });
      setSelect2BC(parent);
  });
}

function optionsToQuery(elm) {
  let query = [];
  $(elm).children().each(function (i, option) {
      if ($(option).val() !== "") {
          query.push('category:' + $(option).val());
      }
  });
  return query.join(" OR ");
}

function setSelect2BC(elm) {
  $(elm).select2({
      ajax: {
          url: webApplicationBaseURL + 'servlets/solr/select',
          data: function (params) {
              params.term = (params.term == null) ? "" : params.term;
              return {
                  q: '-id:kartdok_bc OR category *' + params.term.replace(/\./g, "_") + "* OR " + 'label.en *' + params.term + "* OR " + 'label.de *' + params.term + "*",
                  fq: 'classification:kartdok_bc',
                  rows: 2147483647,
                  sort: 'category ASC',
                  wt: 'json',
                  core: 'classification'
              };
          },
          dataType: 'json',
          processResults: function (data) {
              let res = {
                  results: $.map(data.response.docs, function(obj) {
                      let text = obj['label.' + $("html").attr("lang")];
                      if (text === undefined) {
                          text = obj['label.en'][0]
                      }
                      else {
                          text = text[0];
                      }
                      return { id: obj.category, text: text };
                  })
              };
              addDefault(elm, res);
              return res;
          },
      },
      minimumInputLength: 0,
      language: $("html").attr("lang")
  });
}

function addDefault(elm, res) {
  $(elm).children().each(function (i, option) {
      let found = false;
      $.each(res.results, function (i, solrOption) {
          if (solrOption.id === $(option).val()) {
              found = true;
              return false;
          }
      });
      if (!found) {
          if ($(option).val() !== "") {
              res.results.push({id: $(option).val(), text: $(option).html()})
          }
      }
  })
}

function getOptionWithValBC(elm, val) {
  return $(elm).find("option[value='" + val + "']");
}
