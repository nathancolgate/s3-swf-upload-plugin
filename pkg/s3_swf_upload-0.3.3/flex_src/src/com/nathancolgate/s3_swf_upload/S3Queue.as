package com.nathancolgate.s3_swf_upload {
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
  import flash.external.ExternalInterface;
	import flash.net.FileReference;
	import com.nathancolgate.s3_swf_upload.*;
	
  public class S3Queue extends ArrayCollection {
	
		// S3 Interaction Vars
		private var _signatureUrl:String;
		private var _prefixPath:String;

		public var currentSignature:S3Signature;		

		public function S3Queue(signatureUrl:String,
														prefixPath:String,
														source:Array = null) {
															
			_signatureUrl = signatureUrl;
			_prefixPath	  = prefixPath;
			super(source);

			// Outgoing calls
			this.addEventListener(CollectionEvent.COLLECTION_CHANGE, changeHandler);
			// Incoming calls
			ExternalInterface.addCallback("startUploading", startUploadingHandler);
			ExternalInterface.addCallback("clearQueue", clearHandler);
			ExternalInterface.addCallback("stopUploading", stopUploadingHandler);
		}
		
		public function uploadNextFile():void{
			// ExternalInterface.call('s3_swf.jsLog','uploadNextFile');
			// ExternalInterface.call('s3_swf.jsLog','Start uploadNextFile...');
			var next_file:FileReference = FileReference(this.getItemAt(0));
			currentSignature = new S3Signature(next_file,_signatureUrl,_prefixPath);
			// ExternalInterface.call('s3_swf.jsLog','End uploadNextFile');
		}
		
		// whenever the queue changes this function is called 
		private function changeHandler(event:CollectionEvent):void{
			// ExternalInterface.call('s3_swf.jsLog','changeHandler');
			// ExternalInterface.call('s3_swf.jsLog','Calling onQueueChange...');
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onQueueChange',this.toJavascript());
			// ExternalInterface.call('s3_swf.jsLog','onQueueChange called');      
		}
		
		// Remove all files from the upload queue;
		private function clearHandler():void{
			// ExternalInterface.call('s3_swf.jsLog','clearHandler');
			// ExternalInterface.call('s3_swf.jsLog','Removing All...');
			this.removeAll();
			// ExternalInterface.call('s3_swf.jsLog','All removed');
			// ExternalInterface.call('s3_swf.jsLog','Calling onQueueClear...');
			ExternalInterface.call(S3Uploader.s3_swf_obj+'.onQueueClear',this.toJavascript());
			// ExternalInterface.call('s3_swf.jsLog','onQueueClear called');
		}

		// Start uploading the files from the queue
		private function startUploadingHandler():void{
			// ExternalInterface.call('s3_swf.jsLog','startUploadingHandler');
			if (this.length > 0){
				// ExternalInterface.call('s3_swf.jsLog','Calling onUploadingStart...');
				ExternalInterface.call(S3Uploader.s3_swf_obj+'.onUploadingStart');
				// ExternalInterface.call('s3_swf.jsLog','onUploadingStart called');
	      // ExternalInterface.call('s3_swf.jsLog','Uploading next file...');
				uploadNextFile();
				// ExternalInterface.call('s3_swf.jsLog','Next file uploaded');
			} else {
				// ExternalInterface.call('s3_swf.jsLog','Calling onQueueEmpty...');
				ExternalInterface.call(S3Uploader.s3_swf_obj+'.onQueueEmpty',this);
				// ExternalInterface.call('s3_swf.jsLog','onQueueEmpty called');
			}
		}
		
		// Cancel Current File Upload
		// Which stops all future uploads as well
		private function stopUploadingHandler():void{
			// ExternalInterface.call('s3_swf.jsLog','stopUploadingHandler');
			if (this.length > 0){
				var current_file:FileReference = FileReference(this.getItemAt(0));
				// ExternalInterface.call('s3_swf.jsLog','Cancelling current file...');
				current_file.cancel();

				currentSignature.s3upload.removeListeners();

				// ExternalInterface.call('s3_swf.jsLog','Current file cancelled');
				// ExternalInterface.call('s3_swf.jsLog','Calling onUploadingStop...');
				ExternalInterface.call(S3Uploader.s3_swf_obj+'.onUploadingStop');
				// ExternalInterface.call('s3_swf.jsLog','onUploadingStop called');
	    } else {
				// ExternalInterface.call('s3_swf.jsLog','Calling onQueueEmpty...');
				ExternalInterface.call(S3Uploader.s3_swf_obj+'.onQueueEmpty',this.toJavascript());
				// ExternalInterface.call('s3_swf.jsLog','onQueueEmpty called');
			}
		}
		
		// This is a rather silly function to need, especially since it worked at one point
		// In flash player 10.1, you could no longer send files over external reference
		// This is the hack to get around the problem.  Essentially: turn all those 
		// Files into objects
		// August 27, 2010 - NCC@BNB
		public function toJavascript():Object {
			var faux_queue:Object = new Object();
      faux_queue.files = new Array();
			for (var i:int = 0;i < source.length; i++) {
				faux_queue.files[i] = new Object();
				faux_queue.files[i].name = source[i].name;
	      faux_queue.files[i].size = source[i].size;
	      faux_queue.files[i].type = source[i].type;
      }
			return faux_queue;
		}

	}
}
