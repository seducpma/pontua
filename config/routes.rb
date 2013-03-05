ActionController::Routing::Routes.draw do |map|
  map.resources :financeiros

  map.resources :relatorios

  map.resources :obreiros

  map.resources :funcionarios_familiares
  map.resources :familiares
  map.resources :funcionarios_moradores

  map.resources :funcionarios
  map.resources :classes
  map.resources :informativos
  map.resources :logs
  map.resources :unidades
 

  map.consultaempresa '/consultaempresa', :controller => 'unidades', :action => 'consultaempresa'
  map.consultaobreiro '/consultaobreiro', :controller => 'obreiros', :action => 'consultaobreiro'
  map.consultafuncionario '/consultafuncionario', :controller => 'funcionarios', :action => 'consultafuncionario'
  map.consultafamiliar '/consultafamiliar', :controller => 'familiares', :action => 'consultafamiliar'
  map.consulta_unidade_nome '/consulta_unidade_nome', :controller => 'unidades', :action => 'consulta_nome'
  map.consulta_funcionario_nome '/consulta_funcionario_nome', :controller => 'funcionarios', :action => 'consulta_nome'
  map.consulta_obreiro_nome '/consulta_obreiro_nome', :controller => 'obreiros', :action => 'consulta_nome'
  map.lista_familiares '/lista_familiares', :controller => 'funcionarios', :action => 'lista_familiares'
  map.consulta_relatorio '/consulta_relatorio', :controller => 'relatorios', :action => 'consulta_relatorio'
  map.consultarelatorio '/consultarelatorio', :controller => 'relatorios', :action => 'consultarelatorio'
  map.consulta_financeiro '/consulta_financeiro', :controller => 'financeiros', :action => 'consulta_financeiro'
  map.consultafinanceiro '/consultafinanceiro', :controller => 'financeiros', :action => 'consultafinanceiro', :collection => {:to_print => :get}

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
