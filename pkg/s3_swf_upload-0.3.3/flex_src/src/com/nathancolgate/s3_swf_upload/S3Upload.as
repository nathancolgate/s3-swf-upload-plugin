package com.nathancolgate.s3_swf_upload {
	
	import com.elctech.S3UploadOptions;
	import com.elctech.S3UploadRequest;
  import flash.external.ExternalInterface;
	import com.nathancolgate.s3_swf_upload.*;
	import flash.net.*;
	import flash.events.*;
	
  public class S3Upload extends S3UploadRequest {
		
		private var _upload_options:S3UploadOptions;
	
		public function S3Upload(s3_upload_options:S3UploadOptions) {
			super(s3_upload_options);
			
			_upload_options = s3_upload_options;
			
			addEventListener(Event.OPEN, openHandler);
	    addEventListener(ProgressEvent.PROGRESS, progressHandler);
	    addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	    addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
	    addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, completeHandler);
	
		  try {
				var next_file:FileReference = FileReference(Globals.queue.getItemAt(0));
				this.upload(next_file);
			} catch(error:Error) {
				ExternalInterface.call(S3Uploader.s3_swf_obj+'.onUploadError',_upload_options,error);
	    }
		}
		
		// called after the file is opened before _upload_options    
		private function openHandler(event:Event):void{
			// This should only happen once per file
			// But sometimes, after stopping and restarting the queeue
			// It gets called multiple times
			// BUG BUG BUG!
			// ExternalInterface.call('s3_swf.jsLog','openHandler');
			// ExternalInterface.call('s3_swf.jsLog','Calling onUploadOpen...');
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onUploadOpen',_upload_options,event);
			// ExternalInterface.call('s3_swf.jsLog','onUploadOpen called');
		}

		// called during the file _upload_options of each file being _upload_optionsed
		// we use this to feed the progress bar its data
		private function progressHandler(progress_event:ProgressEvent):void {
			// ExternalInterface.call('s3_swf.jsLog','progressHandler');
			// ExternalInterface.call('s3_swf.jsLog','Calling onUploadProgress...');
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onUploadProgress',_upload_options,progress_event);
			// ExternalInterface.call('s3_swf.jsLog','onUploadProgress called');
		}

		// only called if there is an  error detected by flash player browsing or _upload_optionsing a file   
		private function ioErrorHandler(io_error_event:IOErrorEvent):void{
			// ExternalInterface.call('s3_swf.jsLog','ioErrorHandler');
			// ExternalInterface.call('s3_swf.jsLog','Calling onUploadIOError...');
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onUploadIOError',_upload_options,io_error_event);
			// ExternalInterface.call('s3_swf.jsLog','onUploadIOError called');
		}    

		private function httpStatusHandler(http_status_event:HTTPStatusEvent):void {
			// ExternalInterface.call('s3_swf.jsLog','httpStatusHandler');
			// ExternalInterface.call('s3_swf.jsLog','Calling onUploadHttpStatus...');
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onUploadHttpStatus',_upload_options,http_status_event);
			// ExternalInterface.call('s3_swf.jsLog','onUploadHttpStatus called');
		}
		
		// only called if a security error detected by flash player such as a sandbox violation
		private function securityErrorHandler(security_error_event:SecurityErrorEvent):void{
			// ExternalInterface.call('s3_swf.jsLog','securityErrorHandler');
			// ExternalInterface.call('s3_swf.jsLog','Calling onUploadSecurityError...');
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onUploadSecurityError',_upload_options,security_error_event);
			// ExternalInterface.call('s3_swf.jsLog','onUploadSecurityError called');
		}
        
		private function completeHandler(event:Event):void{
            // prepare to destroy
            removeListeners();
            removeEventListener(Event.OPEN, openHandler);
            removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, completeHandler);

            // callback
			// ExternalInterface.call('s3_swf.jsLog','completeHandler');
			// ExternalInterface.call('s3_swf.jsLog','Calling onUploadComplete...');
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onUploadComplete',_upload_options,event);
			// ExternalInterface.call('s3_swf.jsLog','onUploadComplete called');
			// ExternalInterface.call('s3_swf.jsLog','Removing item from global queue...');

            // destroy
            Globals.queue.removeItemAt(0);

			// ExternalInterface.call('s3_swf.jsLog','Item removed from global queue');
			if (Globals.queue.length > 0){
				// ExternalInterface.call('s3_swf.jsLog','Uploading next item in global queue...');
				Globals.queue.uploadNextFile();
				// ExternalInterface.call('s3_swf.jsLog','Next ttem in global queue uploaded');
			} else {
				// ExternalInterface.call('s3_swf.jsLog','Calling onUploadingFinish...');
				ExternalInterface.call(S3Uploader.s3_swf_obj+'.onUploadingFinish');
				// ExternalInterface.call('s3_swf.jsLog','onUploadingFinish called');
			}
		}
		
	}
}