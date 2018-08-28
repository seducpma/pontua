ActionController::Routing::Routes.draw do |map|
  map.resources :cargos
  map.resources :titulacaos
  map.resources :titulo_professors, :collection => {:impressao => :get, :consulta_titulo => :get}
  map.resources :tempo_servicos, :collection => {:impressao => :get}
  map.resources :professors, :collection => {:consulta_ficha => :get, :impressao => :get, :consulta_erros => :get}

  map.resources :classes
  map.resources :informativos
  map.resources :logs
  map.resources :unidades


  map.resource :consulta, :collection => {:consulta_titulo => :get, :consulta_ppu => :get, :consulta_geral => :get, :impressao_geral => :get, :consulta_funcao => :get,  :consulta_unidade => :get, :consulta_unidade_funcao => :get}

  map.sobre '/sobre', :controller => 'professors', :action => 'sobre'
  map.altera_tabelas '/altera_tabelas', :controller => 'professors', :action => 'altera_tabelas'
  map.atualizar '/atualizar', :controller => 'professors', :action => 'atualizar'
  map.relatorio_por_funcao '/relatorio_por_funcao', :controller => 'consultas', :action => 'relatorio_por_funcao'
  map.consulta_unidade_funcao1 '/consulta_unidade_funcao', :controller => 'consultas', :action => 'consulta_unidade_funcao'
  map.consulta_funcao1 '/consulta_funcao', :controller => 'consultas', :action => 'consulta_funcao'
  map.consulta_unidade1 '/consulta_unidade', :controller => 'consultas', :action => 'consulta_unidade'
  map.total_geral_pontuacao'/total_geral_pontuacao', :controller => 'professors', :action => 'total_geral_pontuacao'
  map.consulta_ficha_pontuacao '/consulta_ficha_pontuacao', :controller => 'professors', :action => 'consulta_ficha_pontuacao'
  map.consulta_erros_pontuacao '/consulta_erros_pontuacao', :controller => 'professors', :action => 'consulta_erros_pontuacao'


  map.consulta_ficha '/consulta_ficha', :controller => 'professors', :action => 'consulta_ficha'
  map.consulta_erros '/consulta_errosa', :controller => 'professors', :action => 'consulta_erros'
  map.consulta_tempo '/consulta_tempo', :controller => 'tempo_servicos', :action => 'consulta'
  map.consulta_tempo_servico '/consulta_tempo_servico', :controller => 'tempo_servicos', :action => 'consulta_tempo_servico'
  map.consulta_titulo_professor '/consulta_titulo_professor', :controller => 'titulo_professors', :action => 'consulta_titulo_professor'
  map.consulta_titulacao '/consulta_titulacao', :controller => 'titulo_professors', :action => 'consulta'
  map.consulta_titulacao_professor'/consulta_titulacao_professor', :controller => 'titulo_professors', :action => 'consulta_titulacao_professor'
  map.consulta_titula'/consulta_titula', :controller => 'titulo_professors', :action => 'consulta_titula'
  map.consultaprofessor '/consultaprofessor', :controller => 'professors', :action => 'consultaprofessor'
  map.impressao_consulta '/impressao_consulta', :controller => 'professors', :action => 'impressao_consulta'


  map.consulta_unidade_nome '/consulta_unidade_nome', :controller => 'unidades', :action => 'consulta_nome'
  map.consulta_funcionario_nome '/consulta_funcionario_nome', :controller => 'funcionarios', :action => 'consulta_nome'
  map.consulta_professor_nome '/consulta_professor_nome', :controller => 'professors', :action => 'consulta_nome'

  map.consulta_relatorio '/consulta_relatorio', :controller => 'relatorios', :action => 'consulta_relatorio'
  map.consulta_titulo_professor '/consulta_titulo_professor', :controller => 'relatorios', :action => 'consulta_titulo_professor'
  map.consulta_financeiro '/consulta_financeiro', :controller => 'financeiros', :action => 'consulta_financeiro'
  map.consultafinanceiro '/consultafinanceiro', :controller => 'financeiros', :action => 'consultafinanceiro', :collection => {:to_print => :get}


  map.resources :roles_users, :collection => {:lista_users => :get}
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users
  map.resource :session
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resource :password
  map.reset_password '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.resources :users
  map.resource :session
  map.home '', :controller => 'home', :action => 'index'
  map.root :controller => "home"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.geo "/geos/geo/:id", :controller => "geos", :action => "geo"

end
