if (google) {
    google.load('search', '1');
}

var imageSearch = null;
var image_url = "";
var image_full_url = "";
var image_id = 0;
var image_ready = false;

var co = 0;

function searchComplete() {
    // Check that we got results
    if (imageSearch.results && imageSearch.results.length > 0) {

        var results = imageSearch.results;

        if (results.length > 0) {
            image_url = results[0].tbUrl;
            image_full_url = results[0].unescapedUrl;
        } else {
            image_url = "";
            image_full_url = "";
        }

        image_ready = true;

    }
}

function OnLoad() {

    // Create an Image Search instance.
    imageSearch = new google.search.ImageSearch();

    // Set searchComplete as the callback function when a search is 
    // complete.  The imageSearch object will have results in it.
    imageSearch.setSearchCompleteCallback(this, searchComplete, null);

    //imageSearch.setResultSetSize(google.search.Search.LARGE_RESULTSET);

    imageSearch.setRestriction(
          google.search.Search.RESTRICT_SAFESEARCH,
          google.search.Search.SAFESEARCH_STRICT);

    /*imageSearch.setRestriction(
    google.search.ImageSearch.RESTRICT_IMAGESIZE,
    google.search.ImageSearch.IMAGESIZE_LARGE);*/


    // Find me a beautiful car.
    // imageSearch.execute("emma stone");


    // Include the required Google branding
    // google.search.Search.getBranding('branding');
}

function searchForImage(text, id) {
    image_id = id;
    image_ready = false;
    if (imageSearch) {
        imageSearch.execute(text);
    }
}

function getGoogleImageLink(id) {
    if (image_id == id && image_ready) {
        var t = new Object();
        t.tbUrl = image_url;
        t.fullUrl = image_full_url;
        return t;
    } else return null;
}

if (google) {
    google.setOnLoadCallback(OnLoad);
}

