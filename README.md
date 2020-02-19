# About CKB

CKB is the layer 1 of Nervos Network, a public/permissionless blockchain. CKB uses [Proof of Work](https://en.wikipedia.org/wiki/Proof-of-work_system) and [improved Nakamoto concensus](https://medium.com/nervosnetwork/breaking-the-throughput-limit-of-nakamoto-consensus-ccdf65fe0832) to achieve maximized performance on average hardware and internet condition, without sacrificing decentralization and security which are the core value of blockchain.

# CKB Testnet Faucet

[![License](https://img.shields.io/badge/license-MIT-green)](https://github.com/shaojunda/ckb-testnet-faucet/blob/develop/LICENSE)
[![Telegram Group](https://cdn.rawgit.com/Patrolavia/telegram-badge/8fe3382b/chat.svg)](https://t.me/nervos_ckb_dev)

CKB Testnet Faucet is a [Testnet Aggron](https://github.com/nervosnetwork/ckb#join-a-network) faucet built with React and Ruby on Rails.

It supports claim ckb testnet tokens.

## Prerequisites

- [PostgreSQL](https://www.postgresql.org/) 9.4 and above
- [Ruby](https://www.ruby-lang.org/en/news/2019/08/28/ruby-2-6-4-released/) 2.6.4 and above
- [Redis](https://redis.io/) 4.0.9 and above
- [ckb-sdk-ruby](https://github.com/nervosnetwork/ckb-sdk-ruby) 0.28.0 and above

## Initial Project

```shell
$ cd ckb-testnet-faucet/
$ EDITOR=vim rails credentials:edit (overwrite configs)
$ bin/setup
$ bundle exec rake migration:create_official_account
```

### credential file example:

```yml
REDIS:
  URL: redis://172.31.16.215:7379/11
DB:
  USERNAME: "your db username"
  PASSWORD: "your db password"
  HOST: localhost
  PORT: 5432
  RAILS_MAX_THREADS: 30
CKB_NODE_URL: "http://localhost"
OFFICIAL_WALLET_PRIVATE_KEY: "your private key"
SECP_CELL_TYPE_HASH: "0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8"
ALLOWED_IPS:
  - 127.0.0.1
AGGRON_EXPLORER_HOST: "https://explorer.nervos.org/aggron"
secret_key_base: "your secret key base"
```

## Running Test

```shell
$ bundle exec rails test
```

## Run Project

```shell
# before run project you need to use `get_lock_hash_index_states` rpc check ckb indexer status
$ bundle exec rails s
# start send capacity service
$ ruby lib/claim_event_processor.rb
```

## Deployment

You can deploy this via [mina](https://github.com/mina-deploy/mina)

```shell
$ mina setup
$ mina production deploy
```

## How to Contribute

CKB Testnet Faucet is an open source project and your contribution is very much appreciated. Please check out [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines about how to proceed.

## License

CKB Testnet Faucet is released under the terms of the MIT license. See [LICENSE](LICENSE) for more information or see [https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT).
