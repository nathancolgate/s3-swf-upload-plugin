module S3SwfUpload
  module ViewHelpers
    def s3_swf_upload_tag(options = {})
      buttonWidth             = options[:buttonWidth]  || 100
      buttonHeight            = options[:buttonHeight] || 30
    	flashVersion            = options[:height] || '9.0.0'
    	queueSizeLimit          = options[:queueSizeLimit] || 100
    	fileSizeLimit           = options[:fileSizeLimit] || 524288000
      fileTypes               = options[:fileTypes] || '*.*'
      fileTypeDescs           = options[:fileTypeDescs] || 'All Files'
      selectMultipleFiles     = options.has_key?(:selectMultipleFiles) ? options[:selectMultipleFiles] : true
      keyPrefix               = options[:keyPrefix] || ''
    	signaturePath           = options[:signaturePath] || '/s3_uploads.xml'
      swfFilePath             = options[:swfFilePath] || '/flash/s3_upload.swf'
    	buttonUpPath            = options[:buttonUpPath] || '/flash/s3_up_button.gif'
    	buttonOverPath          = options[:buttonOverPath] || '/flash/s3_over_button.gif'
    	buttonDownPath          = options[:buttonDownPath] || '/flash/s3_down_button.gif'
    	                                 
    	onFileAdd							  = options[:onFileAdd] || false		
    	onFileRemove						= options[:onFileRemove] || false
    	onFileSizeLimitReached 	= options[:onFileSizeLimitReached] || false	
    	onFileNotInQueue				= options[:onFileNotInQueue] || false	
    	                                 
    	onQueueChange						= options[:onQueueChange] || false
    	onQueueClear						= options[:onQueueClear] || false
    	onQueueSizeLimitReached	= options[:onQueueSizeLimitReached] || false
    	onQueueEmpty						= options[:onQueueEmpty] || false
    	                                 
    	onUploadingStop					= options[:onUploadingStop] || false
    	onUploadingStart				= options[:onUploadingStart] || false
    	onUploadingFinish				= options[:onUploadingFinish] || false
    	                                 
    	onSignatureOpen					= options[:onSignatureOpen] || false
    	onSignatureProgress			= options[:onSignatureProgress] || false
    	onSignatureHttpStatus		= options[:onSignatureHttpStatus] || false
    	onSignatureComplete			= options[:onSignatureComplete] || false
    	onSignatureSecurityError= options[:onSignatureSecurityError] || false
    	onSignatureIOError			= options[:onSignatureIOError] || false
    	onSignatureXMLError			= options[:onSignatureXMLError] || false
    	                                 
    	onUploadOpen						= options[:onUploadOpen] || false
    	onUploadProgress				= options[:onUploadProgress] || false
    	onUploadHttpStatus			= options[:onUploadHttpStatus] || false
    	onUploadComplete				= options[:onUploadComplete] || false
    	onUploadIOError					= options[:onUploadIOError] || false
    	onUploadSecurityError		= options[:onUploadSecurityError] || false
    	onUploadError						= options[:onUploadError] || false
    	
      @include_s3_upload ||= false 
      @count ||= 1
      
      out = ''

      if !@include_s3_upload
        out << javascript_include_tag('s3_upload')
        @include_s3_upload = true
      end

      out << "\n<script type=\"text/javascript\">\n"
      out << "var s3_swf_#{@count}_object = s3_swf_init('s3_swf_#{@count}', {\n"
      out << "buttonWidth: #{buttonWidth},\n" if buttonWidth
      out << "buttonHeight: #{buttonHeight},\n" if buttonHeight
      out << "flashVersion: '#{flashVersion}',\n" if flashVersion
      out << "queueSizeLimit: #{queueSizeLimit},\n" if queueSizeLimit
      out << "fileSizeLimit: #{fileSizeLimit},\n" if fileSizeLimit
      out << "fileTypes: '#{fileTypes}',\n" if fileTypes
      out << "fileTypeDescs: '#{fileTypeDescs}',\n" if fileTypeDescs
      out << "selectMultipleFiles: #{selectMultipleFiles.to_s},\n"
      out << "keyPrefix: '#{keyPrefix}',\n" if keyPrefix
      out << "signaturePath: '#{signaturePath}',\n" if signaturePath
      out << "swfFilePath: '#{swfFilePath}',\n" if swfFilePath
      out << "buttonUpPath: '#{buttonUpPath}',\n" if buttonUpPath
      out << "buttonOverPath: '#{buttonOverPath}',\n" if buttonOverPath
      out << "buttonDownPath: '#{buttonDownPath}',\n" if buttonDownPath
      out << "swfVarObj: 's3_swf_#{@count}_object',\n"
       
      out << %(onFileAdd: function(file){
                #{onFileAdd}
              },) if onFileAdd
      out << %(onFileRemove: function(file){
                #{onFileRemove}
              },) if onFileRemove
      out << %(onFileSizeLimitReached: function(file){
                #{onFileSizeLimitReached}
              },) if onFileSizeLimitReached
      out << %(onFileNotInQueue: function(file){
                #{onFileNotInQueue}
              },) if onFileNotInQueue
              
      out << %(onQueueChange: function(queue){
                #{onQueueChange}
              },) if onQueueChange
      out << %(onQueueSizeLimitReached: function(queue){
                #{onQueueSizeLimitReached}
              },) if onQueueSizeLimitReached
      out << %(onQueueEmpty: function(queue){
                #{onQueueEmpty}
              },) if onQueueEmpty
      out << %(onQueueClear: function(queue){
                #{onQueueClear}
              },) if onQueueClear
              
      out << %(onUploadingStart: function(){
                #{onUploadingStart}
              },) if onUploadingStart
      out << %(onUploadingStop: function(){
                #{onUploadingStop}
              },) if onUploadingStop
      out << %(onUploadingFinish: function(){
                #{onUploadingFinish}
              },) if onUploadingFinish
              
      out << %(onSignatureOpen: function(file,event){
                #{onSignatureOpen}
              },) if onSignatureOpen
      out << %(onSignatureProgress: function(file,progress_event){
                #{onSignatureProgress}
              },) if onSignatureProgress
      out << %(onSignatureSecurityError: function(file,security_error_event){
                #{onSignatureSecurityError}
              },) if onSignatureSecurityError
      out << %(onSignatureComplete: function(file,event){
                #{onSignatureComplete}
              },) if onSignatureComplete
      out << %(onSignatureIOError: function(file,io_error_event){
                #{onSignatureIOError}
              },) if onSignatureIOError
      out << %(onSignatureHttpStatus: function(file,http_status_event){
                #{onSignatureHttpStatus}
              },) if onSignatureHttpStatus
      out << %(onSignatureXMLError: function(file,error_message){
                #{onSignatureXMLError}
              },) if onSignatureXMLError
              
      out << %(onUploadError: function(upload_options,error){
                #{onUploadError}
              },) if onUploadError
      out << %(onUploadOpen: function(upload_options,event){
                #{onUploadOpen}
              },) if onUploadOpen
      out << %(onUploadProgress: function(upload_options,progress_event){
                #{onUploadProgress}
              },) if onUploadProgress
      out << %(onUploadIOError: function(upload_options,io_error_event){
                #{onUploadIOError}
              },) if onUploadIOError
      out << %(onUploadHttpStatus: function(upload_options,http_status_event){
                #{onUploadHttpStatus}
              },) if onUploadHttpStatus
      out << %(onUploadSecurityError: function(upload_options,security_error_event){
                #{onUploadSecurityError}
              },) if onUploadSecurityError
      out << %(onUploadComplete: function(upload_options,event){
                #{onUploadComplete}
              },) if onUploadComplete
      # This closes out the object (no comma)
      out << "foo: 'bar'"              
      out << "});\n"
      out << "</script>\n"
      out << "<div id=\"s3_swf_#{@count}\">\n"
      out << "Please <a href=\"http://www.adobe.com/go/getflashplayer\">Update</a> your Flash Player to Flash v#{flashVersion} or higher...\n"
      out << "</div>\n"
      
      @count += 1
      out
    end

  end
end

ActionView::Base.send(:include, S3SwfUpload::ViewHelpers)
