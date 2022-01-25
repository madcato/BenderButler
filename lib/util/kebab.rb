class String
    def snakecase
        #gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr('-', '_').
        gsub(/\s/, '_').
        gsub(/__+/, '_').
        downcase
    end

    def kebabcase
        gsub(/á/, 'a').
        gsub(/é/, 'e').
        gsub(/í/, 'i').
        gsub(/ó/, 'o').
        gsub(/ú/, 'u').
        gsub(/ñ/, 'n').
        tr('_', '-').
        gsub(/\s/, '-').
        gsub(/__+/, '_').
        downcase.
        gsub(/[\[\]]/, '')
    end
  end