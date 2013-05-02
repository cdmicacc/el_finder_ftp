module ElFinderFtp
  class FtpPathname < Pathname   
    attr_reader :adapter
    
    def initialize(adapter, list_line_or_name, attrs = {})
      @adapter = adapter

      if list_line_or_name.is_a? ElFinderFtp::FtpPathname
        super(list_line_or_name.to_s)
        self.attrs = list_line_or_name.attrs
      else
        match = list_line_or_name.match /^(\d\d)-(\d\d)-(\d\d) *(\d\d):(\d\d)(..) *([<0-9][^ ]*) *([^ ].*)$/
        if match
          month, day, year, hour, min, ampm, type, filename = match.captures
          month, day, year, hour, min = [month, day, year, hour, min].map { |v| v.to_i }

          hour += 12 if ampm.downcase == 'pm'
          if year < 50
            year += 2000
          else
            year += 1900
          end

          super(filename)
          @time = Time.new(year, month, day, hour, min)

          case type
          when '<DIR>'
            @size = 0
            @type = :directory
          else
            @type = :file
            @size = type
          end
        else
          super(list_line_or_name)
          self.attrs = attrs
        end
      end
    end

    def +(other)
      other = FtpPathname.new(adapter, other) unless FtpPathname === other
      FtpPathname.new(adapter, plus(@path, other.to_s), other.attrs)
    end

    def attrs
      {
        type: @type,
        time: @time,
        size: @size
      }
    end
    def attrs=(val)
      @time = val[:time]
      @type = val[:type]
      @size = val[:size]      
    end

    def atime
      mtime
    end

    def ctime
      mtime
    end

    def mtime
      @time ||= adapter.mtime(self)
    end

    def cleanpath
      self
    end

    def exist?
      adapter.exist?( self )
    end

    def directory?
      type == :directory
    end

    def readable?
      true
    end

    def writable?
      true
    end

    def symlink?
      false
    end

    def file?
      type == :file
    end

    def realpath
      self
    end

    def ftype
      type.to_s
    end

    def type
      @type ||= adapter.path_type(self)
    end

    def size
      unless @type == :directory
        @size ||= adapter.size(self)
      end
    end

    def touch
      adapter.touch(self)
    end

    def rename(to)
      adapter.rename(self, to)
    end

    def mkdir
      adapter.mkdir(self)
      @type = :directory
      @size = 0
    end

    def rmdir
      adapter.rmdir(self)
    end

    def unlink
      adapter.delete(self)
    end

    def read
      adapter.retrieve(self)
    end

    def write(content)
      adapter.store(self, content)
      @size = nil
    end

    def executable?
      false
    end

    def pipe?
      false
    end

    # These methods are part of the base class, but need to be handled specially
    # since they return new instances of this class
    # The code below unwraps the pathname, invokces the original method on it,
    # and then wraps the result into a new, properly constructed instance of this class
    {
      'dirname'     => {                 :args => '(*args)'         },
      'basename'    => {                 :args => '(*args)'         },
      'cleanpath'   => {                 :args => '(*args)'         },
    }.each_pair do |meth, opts|
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{meth}#{opts[:args]}
          v = ::Pathname.new(self.to_s).#{meth}#{opts[:args]}
          self.class.new(@adapter, v.to_s)
        end
      METHOD
    end
  end
end