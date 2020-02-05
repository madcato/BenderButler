# Propuesta de solución para los datos fake de la versión Demo

La propuesta se basa en crear un fichero de comandos de reemplazo de cadenas. El Rakefile cargaría el fichero y para cada entrada de substitución ejecutaría un comando ruby que substituyera todas las coincidnecias encontradas por un dato fake


Además se podrán crear ficheros de tipo **erb** para generar los ficheros **json** del proyecto. Estos ficheros **erb** son como los ficheros **php**: permiten añadir códigos script ejecutables que pueden generar cualquier fichero. Los **erb** serían las plantillas que generarían los datos falsos.

Una utilidad de *ruby* parecida al **make** llamada **rake** puede procesar todos los ficheros **.json.erb** y **json.yml** que existan, para generar todos los **.json** correspondientes.

* Para generar los datos falsos se puede usar el gem Faker

## Ejemplo de fichero **.json.erb**

	<% Faker::Config.locale = 'es' %>
	
	"[{\"Id\":474,
		\"Nombre\":\"<%= Faker::Name.first_name %>\",
		\"Apellido1\":\"<%= Faker::Name.last_name %>\",
		\"Apellido2\":\"<%= Faker::Name.last_name %>\",
		\"NombreCompleto\":\"<%= Faker::Name.name %>\"
	}]"

También se pueden generar grandes ficheros mediante bucles

	<% Faker::Config.locale = 'es' %>
	"[{
	<% 10000.times { |i| %>
	\"Id\": <%= i %>,
		\"Nombre\":\"<%= Faker::Name.first_name %>\",
		\"Apellido1\":\"<%= Faker::Name.last_name %>\",
		\"Apellido2\":\"<%= Faker::Name.last_name %>\",
		\"NombreCompleto\":\"<%= Faker::Name.name %>\"
	<% } %>
	}]"

## Ejemplo de fichero **.json.yml**

Este fichero se compone de un array de objetos de propiedades **pattern** y **subts**

	-
	  pattern: \\"Nombre\\":\\"[^,]*\\",
	  subst: \"Nombre\":\"<%= Faker::Name.first_name.upcase %>\",
	-
	  pattern: \\"Apellido1\\":\\"[^,]*\\",
	  subst: \"Apellido1\":\"<%= Faker::Name.last_name.upcase %>\",
	-
	  pattern: \\"Apellido2\\":\\"[^,]*\\",
	  subst: \"Apellido2\":\"<%= Faker::Name.last_name.upcase %>\",
	-
	  pattern: \\"NombreCompleto\\":\\"[^,]*\\",
	  subst: \"NombreCompleto\":\"<%= Faker::Name.name.upcase %>\",

## Ejecución **rake**

Los ficheros de entrada(.json.yml) y los ficheros de salida(.json) podrían ubicarse en el mismo directorio. Generando un fichero de nombre **Rakefile** incluyendo el comando que procesa los **yml**, tan solo con ejecutar en linea de comandos la lines: *"$ rake"*, se modificarían los ficheros **.json**. 

Ejemplo de **Rakefile**:

	require 'rake'
	
	src_files = Rake::FileList["*.json.erb"]
	dst_files = src_files.ext ''  # Eliminate .erb extension, output files are <name>.json
	
	task :default => dst_files
	
	rule '.json' => '.json.erb' do |task|
	  template = ERB.new File.read(task.source), nil, "%"
	  File.write(task.name,template.result(binding))
	end
	
	rule '.json' => '.json.yml' do |task|
	  # cp task.source, task.name
	  puts "Updating #{task.name}"
	  
	  substs = YAML.load_file(task.source)
	  
	  text = File.read(task.name)
	  substs.each { |sub| 
	    puts sub["pattern"]
	    #/\\"Nombre\\":\\"[^,]*\\",/
	    text.gsub!(Regexp.new(sub["pattern"])) { |match| ERB.new(sub["subst"]).result(binding) }
	  }
	  puts text
	end
	
	task :touch  do |task|
	  src_files.each do |file|
	    touch file
	  end
	end


## Edición de ficheros **.json.erb**

Para modificar los ficheros json existentes y crear un erb se puede usar un editor de texto que permita Buscar y Reemplzar dentro de todos los ficheros de un directorio. Además debería soportar **Expresiones Regulares**.

### Ejemplo de substitución

Para substituir de:

	\"Nombre\":\"Daniel\",

a 

	\"Nombre\":\"<%= Faker::Name.first_name %>\",

se puede usar este patrón de búsqueda:

	\\"Nombre\\":\\"[^,]*\\",

reemplazandolo por:

	\"Nombre\":\"<%= Faker::Name.first_name %>\",

## Edición de ficheros **.json.yml**

En los ficheros **.json.yml** hay que incluir todas las substituciones que se deben realizar en el fichero original. En este caso no se genera un fichero a partir del **.json.erb**, sino que el fichero **.json** es procesado substituyendo todas las búsquedas por los textos especificados en el **.json.yml**

### Requerimientos 

Instalar el gem Faker:

	$ sudo gem install faker

## Uso


Para generar los ficheros ejecutar el siguiente comando en el directorio donde se encuentra el fichero Rakefile y los json:

	$ rake

Esto regenerará aquellos ficheros que hayan sido borrados o aquellos cuyo fichero **.json.erb** haya sido modificador.

Para generar solo uno de los **.json**

	$ rake fichero.json

Para forzar la regeneración de todos los ficheros, usar:

	$ rake regenerate

Para regenerar solo un fichero:

	$ touch DatosPrueba.erb.json
	$ rake


## Enlaces 

- [Rakefile documentation](http://rake.rubyforge.org/doc/rakefile_rdoc.html)
- [Faker gem github](https://github.com/stympy/faker)
- [Yaml doc](http://www.yaml.org/spec/1.2/spec.html)