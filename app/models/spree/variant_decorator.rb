module Spree
	Variant.class_eval do
		mount_uploader :file, Spree::FilesUploader
	end
end
