module ElFinderFtp
  module Action
    class << self
      def included(klass)
        klass.send(:extend, ElFinderFtp::ActionClass)
      end
    end
  end

  module ActionClass
    def el_finder_ftp(name = :elfinder, &block)
      self.send(:define_method, name) do
        h, r = ElFinderFtp::Connector.new(instance_eval(&block)).run(params)
        headers.merge!(h)
        if r.include?(:file_data)
          send_data r[:file_data], type: r[:mime_type], disposition: r[:disposition], filename: r[:filename]
        else
          render (r.empty? ? {:nothing => true} : {:json => r}), :layout => false
        end
      end
    end
  end
end
