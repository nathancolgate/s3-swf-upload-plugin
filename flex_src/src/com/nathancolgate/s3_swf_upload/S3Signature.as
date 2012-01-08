package com.nathancolgate.s3_swf_upload {
	
	import com.elctech.S3UploadOptions;
	import com.nathancolgate.s3_swf_upload.*;
  import flash.external.ExternalInterface;
	import com.adobe.net.MimeTypeMap;

	import flash.net.*
	import flash.events.*
	
  public class S3Signature {

		private var upload_options:S3UploadOptions;
		private var _file:FileReference;

		public var s3upload:S3Upload;

		public function S3Signature(file:FileReference,
																	signatureUrl:String,
																	prefixPath:String) {	
			_file														= file;
			
			// Create options list for file s3 upload metadata 
			upload_options									= new S3UploadOptions;
			upload_options.FileSize         = _file.size.toString();
			upload_options.FileName         = getFileName(_file);
			upload_options.ContentType      = getContentType(upload_options.FileName);
			upload_options.key              = prefixPath + upload_options.FileName;
			
			var variables:URLVariables 			= new URLVariables();
			variables.key              			= upload_options.key
			variables.content_type     			= upload_options.ContentType;
		                              		
			var request:URLRequest     			= new URLRequest(signatureUrl);
			request.method             			= URLRequestMethod.GET;
			request.data               			= variables;
			                            		
			var signature:URLLoader       	= new URLLoader();
			signature.dataFormat          	= URLLoaderDataFormat.TEXT;
			signature.addEventListener(Event.OPEN, openHandler);
			signature.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			signature.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			signature.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			signature.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			signature.addEventListener(Event.COMPLETE, completeHandler);
			signature.load(request);
  	}

		private function openHandler(event:Event):void {
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onSignatureOpen',toJavascript(_file),event);
		}

		private function progressHandler(progress_event:ProgressEvent):void {
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onSignatureProgress',toJavascript(_file),progress_event);
		}

		private function securityErrorHandler(security_error_event:SecurityErrorEvent):void {
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onSignatureSecurityError',toJavascript(_file),security_error_event);
		}

		private function httpStatusHandler(http_status_event:HTTPStatusEvent):void {
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onSignatureHttpStatus',toJavascript(_file),http_status_event);
		}

		private function ioErrorHandler(io_error_event:IOErrorEvent):void {
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onSignatureIOError',toJavascript(_file),io_error_event);
		}

  	private function completeHandler(event:Event):void {
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onSignatureComplete',toJavascript(_file),event);
      var loader:URLLoader = URLLoader(event.target);
      var xml:XML  = new XML(loader.data);
      
      // create the s3 options object
      upload_options.policy         = xml.policy;
      upload_options.signature      = xml.signature;
      upload_options.bucket         = xml.bucket;
      upload_options.AWSAccessKeyId = xml.accesskeyid;
      upload_options.acl            = xml.acl;
      upload_options.Expires        = xml.expirationdate;
      upload_options.Secure         = xml.https;

      if (xml.errorMessage != "") {
				ExternalInterface.call(S3Uploader.s3_swf_obj+'.onSignatureXMLError',toJavascript(_file),xml.errorMessage);
				return;
      }
			
      s3upload = new S3Upload(upload_options);
		}
		
		/* MISC */
		
		private function getContentType(fileName:String):String {
			var fileNameArray:Array    = fileName.split(/\./);
			var fileExtension:String   = fileNameArray[fileNameArray.length - 1];
			var mimeMap:MimeTypeMap		 = new MimeTypeMap;
			var contentType:String     = mimeMap.getMimeType(fileExtension);
			return contentType;
		}
		
		private function getFileName(file:FileReference):String {
			var fileName:String = file.name.replace(/^.*(\\|\/)/gi, '').replace(/[^A-Za-z0-9\.\-]/gi, '_');
			return fileName;
		}
		
		// Turns a FileReference into an Object so that ExternalInterface doesn't choke
		private function toJavascript(file:FileReference):Object{
			var javascriptable_file:Object = new Object();
			javascriptable_file.name = file.name;
			javascriptable_file.size = file.size;
			javascriptable_file.type = file.type;
			return javascriptable_file;
		}
		
	}
}