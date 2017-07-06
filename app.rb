
class App 
 def initialize(path_to_file = ARGV[0])
    @path_to_file = path_to_file
  end

	def	check
		if !@path_to_file.nil? 
			puts "#{@path_to_file.partition(".")[0]}.html"
		else
			puts "Add path to file"
		end
	end
	def open_haml_file
		@haml_file = File.open(@path_to_file,'r')	
	end
	def create_html_file(html_content)
		@html_file = File.open("#{@path_to_file.partition(".")[0]}.html.erb",'w')
		@html_file.puts(html_content)
		@html_file.close	
	end
	def convert_haml_to_html
		@html_content = ''
		@lines = []
		@haml_file.readlines.each_with_index do |line , i|
			

			@lines << line

			
		end
		

		
		@lines.each_with_index do |line,i|
			lines = line.split("  ")
			line = lines.last
			
			  case line[0]
				when '#'
					if(line.index('=').nil?)
						if(line.index(' ').nil?)
								create_element('div',{id: line[1..line.length]},nil)
						else
							create_element('div',{id: line[1..line.index(' ')-1]},line[line.index(' ')..line.length])
						end
					else
						if(line.index(' ').nil?)
							create_element('div',{id: line[1..line.index('=')-1]},line[line.index('=')..line.length])
						else
							create_element('div',{id: line[1..line.index('=')-1]},line[line.index('=')..line.length])
						end
					end
				when '.'
					if(line.index('=').nil?)
						if(line.index(' ').nil?)
							create_element('div',{class: line[1..line.length]},nil)
						else
							create_element('div',{class: line[1..line.index(' ')-1]},line[line.index(' ')..line.length])
						end
					else
						if(line.index(' ').nil?)
							create_element('div',{class: line[1..line.index('=')-1]},line[line.index('=')..line.length])
						else
							create_element('div',{class: line[1..line.index('=')-1]},line[line.index('=')..line.length])
						end
					end
				when '%'
					
					i=1
					while i <= 7
						check_element(line,"h#{i}")
						i+= 1
					end
					check_element(line,'div')
					check_element(line,'span')
					check_element(line,'strong')
					check_element(line,'p')
					check_element(line,'ul')
					check_element(line,'li')
					check_element(line,'br')
					check_element(line,'th')
					check_element(line,'a')
					check_element(line,'u')
					check_element(line,'i')
					check_element(line,'table')
					check_element(line,'thead')
					check_element(line,'tbody')
					check_element(line,'tr')
					check_element(line,'th')
					check_element(line,'td')
					check_element(line,'article')
					check_element(line,'section')
					check_element(line,'nav')
					check_element(line,'aside')
				when '='
					content = line[line.index('=')+1..line.length]
					@html_content += make_content_erb(content)
			end
		@haml_file.close
		create_html_file(@html_content)
	end
end
	def create_element(element,attributes,content)
		unless attributes.nil?
			if(!content.nil? && content.index('=').nil?)
				@html_content += "<#{element} #{attributes.keys.first.to_s}=\"#{attributes.values.first.to_s}\">#{content}</#{element}>"
			else
				@html_content += "<#{element} #{attributes.keys.first.to_s}=\"#{attributes.values.first.to_s}\">#{make_content_erb(content)}</#{element}>"
			end
		else
			if(!content.nil? && content.index('=').nil?)
				@html_content += "<#{element}>#{content}</#{element}>"
			else
				@html_content += "<#{element}>#{make_content_erb(content)}</#{element}>"	
			end
		end
	end

	def make_content_erb(content)
		unless content.nil?
		
	    	"<%= #{	content.tr('=','')} %>"
		end
	end

	def check_element(line,element)
		if(line[line.index('%')+1..line.index('%')+element.length] == element)
			element_to_create = element
			check_atribute(line,'.')
			check_atribute(line,'#')
			create_element(element_to_create,@attributes,@content)
		end
	end
	def check_atribute(line,attribute)
		if attribute == '.'
			sym_attr = :class
		end
		if attribute == '#'
			sym_attr = :id
		end
		
		unless line.index(attribute).nil?
				unless line.index(' ').nil?
					if line.index('=').nil?
						@attributes = {sym_attr => line[line.index(attribute)+1..line.index(' ')]}
					else
						@attributes = {sym_attr => line[line.index(attribute)+1..line.index('=')-1]}
					end
				else
					unless line.index('=').nil?
						
						@attributes = {sym_attr => line[line.index(attribute)+1..(line.index('=')-1)]}
					else
						
						@attributes = {sym_attr => line[line.index(attribute)+1..line.length]}	
					end
				end
			unless line.index(' ').nil?

					if line.index('=').nil?
						@content = line[line.index(' ')+1..line.length]
					else
						@content = line[line.index('=')..line.length]
					end

					
			else
				unless line.index('=').nil?
						@content = line[line.index('=')..line.length]
				else
						@content = nil
				end
			end
		end
		unless(line.index('{').nil?)
			unless @attributes.nil?
				#ZMIENIĆ TO BO NIEBEZPIECZNE!!!!
				@attributes = eval(line[line.index('{'),line.index('}')])
			else
				@attributes.merge(eval(line[line.index('{'),line.index('}')]))
			end
		end
	end
end

if __FILE__ == $0
app = App.new
app.check
app.open_haml_file
app.convert_haml_to_html
end