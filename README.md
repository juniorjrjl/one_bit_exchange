# Projeto api para conversão de moeda
repositório do front:

https://github.com/juniorjrjl/one_bit_exchange_front

![technology Ruby](https://img.shields.io/badge/techonolgy-Ruby-red)
![technology Rails](https://img.shields.io/badge/techonolgy-Rails-red)
![techonolgy Redis](https://img.shields.io/badge/techonolgy-redis-red)
![technology Docker](https://img.shields.io/badge/techonolgy-Docker-blue)

## Getting Started

## Pré-requisitos

 - Docker
 - Ruby
 - conta no site https://currencyfreaks.com

crie a network do container usando o seguinte comando:

```
    docker network create one-bit-exchange-net
```

obs.: para rodar os testes use a network `one-bit-exchange-test-net`

coloque na variavel de ambiente EXCHANGE_API_KEY a chave da sua conta para ter acesso aos endpoints da api para consumi-la

inicie a aplicação

```
    docker-compose up
```
