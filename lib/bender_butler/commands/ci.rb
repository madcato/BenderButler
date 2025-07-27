require 'fileutils'

# TODO: Use `linguist` for a better project type detection.

module BenderButler
  module Commands
    class Ci
      ## "ci", "Genera un Rakefile para CI basado en el tipo de proyecto"
      def run
        if rust_project?
          generate_rakefile(rust_rakefile_content)
          print "Rakefile generado para proyecto Rust."
        elsif rails_project?
          generate_rakefile(rails_rakefile_content)
          print "Rakefile generado para proyecto Rails."
        else
          print "Tipo de proyecto no detectado o no soportado aún."
        end
      end

      private

      def rust_project?
        File.exist?('Cargo.toml')
      end

      def rails_project?
        File.exist?('Gemfile') && Dir.exist?('app')
      end

      def generate_rakefile(content)
        File.write('Rakefile', content)
      end

      def rust_rakefile_content
        <<~RAKEFILE
          # Rakefile generado por BenderButler para CI en proyectos Rust

          require 'rake'

          desc 'Compila el proyecto'
          task :build do
            sh 'cargo build'
          end

          desc 'Ejecuta tests'
          task :test do
            sh 'cargo test'
          end

          desc 'Formatea el código'
          task :format do
            sh 'cargo fmt'
          end

          desc 'Linting con Clippy'
          task :lint do
            sh 'cargo clippy -- -D warnings'
          end

          desc 'Build de release para deployment'
          task :deploy do
            sh 'cargo build --release'
            # Agrega aquí lógica de deploy, ej: 'scp target/release/myapp server:/path' o integra con Docker/RSync
            puts 'Deployment completado (personaliza este task para tu setup).'
          end

          desc 'Publica el crate en crates.io'
          task :publish do
            sh 'cargo publish'
          end

          task default: [:format, :lint, :build, :test]
        RAKEFILE
      end

      def rails_rakefile_content
        <<-RAKEFILE
        # Rakefile generado por BenderButler para CI en proyectos Rails
        RAKEFILE
      end
    end
  end
end