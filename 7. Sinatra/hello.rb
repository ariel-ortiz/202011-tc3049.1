require 'sinatra'

get '/' do
  @name = 'Juan Camaney'
  @dwarfs = ['Dwalin', 'Balin', 'Kili', 'Fili', 'Dori',
             'Nori', 'Ori', 'Oin', 'Gloin', 'Bifur',
             'Bofur', 'Bombur', 'Thorin']
  erb :hello
end
