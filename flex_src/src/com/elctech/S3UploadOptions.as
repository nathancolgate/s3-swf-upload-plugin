package com.elctech {
    public class S3UploadOptions {
    	/**
         * Options specified at:
         * http://docs.amazonwebservices.com/AmazonS3/2006-03-01/HTTPPOSTForms.html
       	 */
        public var AWSAccessKeyId:String;
        public var acl:String;
        public var bucket:String;
        public var CacheControl:String;
        public var ContentType:String;
        public var ContentDisposition:String;
        public var ContentEncoding:String;
        public var Expires:String;
        public var key:String;
        public var newKey:String;
        public var policy:String;
        public var successactionredirect:String;
        public var redirect:String;
        public var successactionstatus:String;
        public var signature:String;
        public var xamzsecuritytoken:String;
        public var file:String;
        
        /**
         * Addition field
         */
        public var Secure:String;           /* A flag indicating whether HTTPS should be used. */
        public var FileName:String;
        public var FileSize:String;
    }
}
