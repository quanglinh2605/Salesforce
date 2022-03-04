@IsTest
public class BitlyHttpCalloutMock implements HttpCalloutMock {

    public HttpResponse respond(HttpRequest req) {

        String endpoint = req.getEndpoint();

        if ( endpoint.contains('/oauth/access_token') ) {
            return buildOAuthResponse( req );
        } else if ( endpoint.contains('/v4/shorten') ) {
            return buildShortenResponse( req );
        }

        return null;
    }
    
    private HttpResponse buildOAuthResponse(HttpRequest req) {

        HttpResponse res = new HttpResponse();

        res.setBody('123');
        res.setStatusCode(200);

        return res;
    }

    private HttpResponse buildShortenResponse(HttpRequest req) {

        HttpResponse res = new HttpResponse();

        // See https://dev.bitly.com/api-reference#createBitlink
        // for full details of what a response could include.
        res.setBody(JSON.serializePretty(new Map<String, Object>{
            'link' => 'https://sforce.co/3rUWGZ8'
        }));
        res.setStatusCode(200);

        return res;
    }

}