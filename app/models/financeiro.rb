class Financeiro < ActiveRecord::Base
  belongs_to :unidade
  usar_como_dinheiro :credito, :debito
end
