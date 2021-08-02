# frozen_string_literal: true

class SdkApi
  include Singleton

  METHOD_NAMES = %w(rpc secp_group_out_point secp_code_out_point secp_data_out_point secp_cell_code_hash dao_out_point dao_code_hash dao_type_hash multi_sign_secp_cell_type_hash multi_sign_secp_group_out_point set_secp_group_dep set_dao_dep inspect genesis_block get_block_by_number genesis_block_hash get_block_hash get_header get_block get_tip_header get_tip_block_number get_cells_by_lock_hash get_transaction get_live_cell send_transaction local_node_info get_current_epoch get_epoch_by_number get_peers tx_pool_info get_block_economic_state get_blockchain_info get_peers_state compute_transaction_hash compute_script_hash secp_cell_type_hash dry_run_transaction calculate_dao_maximum_withdraw deindex_lock_hash get_live_cells_by_lock_hash get_lock_hash_index_states get_transactions_by_lock_hash index_lock_hash get_capacity_by_lock_hash get_header_by_number get_cellbase_output_capacity_details set_ban get_banned_addresses estimate_fee_rate get_block_template submit_block).freeze

  attr_reader :api, :indexer_api
  def initialize
    @api = CKB::API.new(host: Rails.application.credentials.CKB_NODE_URL)
    @indexer_api = CKB::Indexer::API.new(Rails.application.credentials.CKB_INDEXER_URL)
    setup_sdk_config
  end

  def setup_sdk_config
    config = CKB::Config.instance
    config.set_api(Rails.application.credentials.CKB_NODE_URL)
  end

  METHOD_NAMES.each do |name|
    define_method name do |*params|
      call_rpc(name, params: params)
    end
  end

  def call_rpc(method, params: [])
    @api.send(method, *params)
  end
end
