
var pageStack = new Array();
var scrollStack = new Array();
//var google_status = 0;
var bing_element = null;

var face_timer_google = null;
var face_timer_bing = null;
var wait_faces = new Array("wait_face2", "wait_face3", "wait_face4", "wait_face5");

function FaceTimer(obj, interval, classname, name) {
    $(obj).html("<div class='" + classname + "'></div>");
    this.name = name;
    this.object = obj;
    this.interval = interval;
    this.timer_id = null;
    this.index = 0;
    this.startTimer = function () {
        this.timer_id = setInterval(function (object) {
            if (object.index >= wait_faces.length) {
                object.stopTimer();
                $(obj).text(object.name + " предпочел не отвечать. Можно конечно подождать еще, но вряд ли что-то изменится.");
                return;
            }

            $(obj).html("<div class='" + wait_faces[object.index] + "'></div>");

            object.index++;

        }, this.interval, this);
    };
    this.stopTimer = function () {
        if (this.timer_id != null) {
            clearInterval(this.timer_id);
        }
    }
}


function showWordByNum(num) {
    //show scrolls by parameter 'num'

    var list = $('li.button a');

    if (null == list)
        return false;

    if (num >= list.length)
        return false;

    $(list[num]).click();

}

function savePage() {
    //save content to stack
    var html = $("#words").html();
    pageStack.push(html);

    //save scroll position to another stack
    var lastButton = $(".lastButton").children("ul").children("li");
    if (null == lastButton) {
        scrollStack.push(0);
    } else {
        var scroll = $(lastButton).scrollTop();
        scrollStack.push(scroll);
    }
}

function loadPage() {
    //load content from page stack
    var html = pageStack.pop();
    $("#words").html(html);

    //load scroll position
    var lastButton = $(".lastButton").children("ul").children("li");
    var scroll = scrollStack.pop();
    if (null != lastButton) {
        $(lastButton).scrollTop(scroll);
    }

    //re-bind events
    registerEvents();
}

function setPage(html) {
    savePage();
    $("#words").html(html);
    registerEvents();
}


function registerEvents() {
    /* Binding a click event handler to the links: */
    $('li.button a').unbind();
    $('li.button a').click(function (e) {

        /* Finding the drop down list that corresponds to the current section: */
        var dropDown = $(this).parent().next();


        if ("" == $(dropDown).text()) {
            var word = ($(this).text());
            var obj = cef.translation.translator();
            var t = (obj.translate(word));

            $(dropDown).html("<ul><li test='1'>" + t + "</li></ul>");
            registerEvents();
        }

        /* Closing all other drop down sections, except the current one */
        $('.dropdown').not(dropDown).slideUp('slow');
        dropDown.slideToggle('slow');
        $('.dropdown').removeClass("lastButton");
        dropDown.addClass('lastButton');

        /* Preventing the default event (which would be to navigate the browser to the link's address) */
        //e.preventDefault();
        return false;
    });

    $('.externallink').unbind();
    $('.externallink').click(function () {
        alert("goto:" + $(this).attr("goto"));
        return false;
    });

    $('.speech').unbind();
    $('.speech').click(function () {
        alert('speak:' + $(this).text());
    });

    $('.view_word').unbind();
    $('.view_word').click(function () {
        var word = ($(this).text());
        var obj = cef.translation.translator();
        var t = (obj.translate(word));
        var link1 = "<a href='javascript:loadPage();'>Вернуться</a>";
        if (t.length < 1400)
            link2 = link1
        else
            var link2 = "<a href='javascript:loadPage();'>Убежать, пока не поздно</a>";

        setPage("<BR>" + link1 + "<div class='word_container'>" + t + "</div>" + link2 + "<BR><BR>");
        registerEvents();
    });

    $('.google_opinion').unbind();
    $('.google_opinion').click(function () {
        $(this).unbind();
        $(this).removeClass("google_opinion");
        $(this).addClass("google_opinion_done");
        var text = $(this).attr("word");
        var obj = $(this);
        //if (1 == google_status) {
        face_timer_google = new FaceTimer(obj, 1000, "face_think1", "Гугле");
        face_timer_google.startTimer();

        var my_image_id = Math.random();
        searchForImage(text, my_image_id);

        //1st December 2011 Google Translation API was shut down.
        //Here is json function that uses undocumentated (hence unstable) features.
        //Also it is violating the x-domain origin policy.

        $.getJSON('http://translate.google.ru/translate_a/t?client=x&text=' + text + '&sl=en&tl=ru',
              function (data) {

                  face_timer_google.stopTimer();

                  //no translation
                  if (data.dict == undefined && data.sentences == undefined) {
                      $(obj).text('гугле в истерике');
                      return;
                  }

                  //clear previous text
                  $(obj).html('Гугле пишет неровным почерком: <br /><br />');

                  //add sub-div with class opinion_bordered
                  var dobj = $("<div class='opinion_bordered'>");
                  $(obj).append(dobj);

                  //parse data
                  if (data.sentences != undefined) {
                      $.each(data.sentences, function (i, item) {
                          if (item.trans == text) { $(dobj).text("фигня какая-то"); return; }
                          $(dobj).append("<a class='popup_trans'>" + item.trans + "</a>");
                      });
                  }

                  if (data.dict != undefined) {
                      if (data.sentences != undefined) {
                          $(dobj).append('<br /><br />');
                      }
                      $.each(data.dict, function (i, item) {

                          //add <br /> after section if it is not the first
                          if (i > 0)
                              $(dobj).append("<br />");

                          // if section name not empty
                          if (item.pos != "") {
                              //add section name
                              $(dobj).append("<a class='section'>" + item.pos + "</a>");
                          }

                          //add terms
                          $.each(item.terms, function (i, term) {
                              $(dobj).append(term + "<br />");
                          })
                      })
                  }

                  var check_img_int = setInterval(function (id) {
                      var t = getGoogleImageLink(id);
                      if (t != null) {
                          clearInterval(check_img_int);
                          if (t.tbUrl != "") {
                              var img = $(dobj).append("<img class='thumbnail' src='" + t.tbUrl + "' goto='" + t.fullUrl + "'></img>");
                              $(".thumbnail").unbind();
                              $(".thumbnail").click(function () {
                                  alert("goto:" + $(this).attr("goto"));
                                  return false;
                              });
                          }
                      }

                  }, 200, my_image_id);

              });

        /*} else {
        $(obj).text("Гугл, кажется, занят");
        }*/
    });

    $('.bing_opinion').unbind();
    $('.bing_opinion').click(function () {
        var text = $(this).attr("word");

        var obj = this;
        $(obj).removeClass("bing_opinion");
        $(obj).addClass("bing_opinion_done");

        face_timer_bing = new FaceTimer(obj, 1000, "face_think2", "Бинк");
        face_timer_bing.startTimer();

        bing_element = obj;
        var s = document.createElement("script");
        s.src = "http://api.microsofttranslator.com/V2/Ajax.svc/GetTranslations?oncomplete=bingcallback&appId=1C2384ED1F2C4F7BD96096567E5F7E7C2A4F386C&text=" + text + "&from=en&to=ru&maxTranslations=5";
        document.getElementsByTagName("head")[0].appendChild(s);
    });

}

window.bingcallback = function (response) {

    face_timer_bing.stopTimer();

    if (null == bing_element)
        return;

    var array = response.Translations;
    var translations = "";
    for (var i = 0; i < array.length; i++) {
        translations = translations + array[i].TranslatedText + ", ";
    }
    $(bing_element).html("<a class='microsoft'> Майкрософт как бы ответственно заявляет: </a>");
    $(bing_element).append("<a class='microsoft_trans'>" + translations.slice(0, translations.length - 2) + "</a>");

    bing_element = null;
}

function clearWords() {
    $("#words").html("");
}

function appendWord(word, color) {
    var code = '<li class="menu"><ul><li class="button"><a href="#" class="' + color + '">' + word + '<span></span></a></li><li class="dropdown"></li></ul></li>';
    $("#words").append(code);
}

/*function google_init() {
google_status = 1;
}*/

$(document).ready(function () {
    /* This code is executed after the DOM has been completely loaded */
    /* Changing thedefault easing effect - will affect the slideUp/slideDown methods: */
    $.easing.def = "easeOutBounce";

    appendWord('Critique', 'red');
    appendWord('of', 'blue');
    appendWord('Pure', 'green');
    appendWord('Reason', 'orange');

    registerEvents();

    alert('notification:main');
    
});