class UpdateContractsContractType < ActiveRecord::Migration[6.1]
  def up
    Contract.where.not(contract_type: 0).update_all(contract_type: 0)
  end
end
