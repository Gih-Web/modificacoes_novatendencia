
CREATE DATABASE mod_novatendencia;
USE mod_novatendencia;

-- =========================
-- TABELAS PRINCIPAIS
-- =========================
CREATE TABLE CLIENTE (
  idCliente INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(150) NOT NULL,
  cpf VARCHAR(14) UNIQUE NOT NULL,
  telefone VARCHAR(20) NOT NULL,
  email VARCHAR(200),
  senha VARCHAR(12),
  foto_perfil LONGBLOB
);

CREATE TABLE ENDERECO (
  idEndereco INT PRIMARY KEY AUTO_INCREMENT,
  cep INT NOT NULL,
  cidade VARCHAR(100) NOT NULL,
  numero VARCHAR(20) NOT NULL,
  complemento VARCHAR(100),
  logradouro VARCHAR(100),
  bairro VARCHAR(100),
  tipo VARCHAR(20)
);

CREATE TABLE CLIENTE_E_ENDERECO (
  cliente_idCliente INT,
  endereco_idEndereco INT,
  CONSTRAINT fk_cliente FOREIGN KEY (cliente_idCliente) REFERENCES CLIENTE(idCliente),
  CONSTRAINT fk_endereco FOREIGN KEY (endereco_idEndereco) REFERENCES ENDERECO(idEndereco)
);

CREATE TABLE CATEGORIA (
  idCategoria INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(50) NOT NULL,
  desconto DOUBLE
);

CREATE TABLE MARCAS (
  IdMarcas INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(45),
  imagem LONGBLOB
);

CREATE TABLE IMAGEM_PRODUTO (
  idImagem_produto INT PRIMARY KEY AUTO_INCREMENT,
  foto LONGBLOB,
  texto_alternativo VARCHAR(45)
);

-- =========================
-- PRODUTOS (atualizado)
-- =========================
CREATE TABLE PRODUTOS (
  idProdutos INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(45),
  descricao TEXT(500),
  quantidade INT NOT NULL,
  preco DOUBLE NOT NULL,
  tamanho VARCHAR(45),
  cor VARCHAR(45),
  codigo INT NOT NULL,
  preco_promocional DOUBLE,
  novidade TINYINT(1) DEFAULT 0,
  destaque TINYINT(1) DEFAULT 0,
  marcas_id INT,
  CONSTRAINT fk_produto_marca FOREIGN KEY (marcas_id) REFERENCES MARCAS(IdMarcas)
);

-- =========================
-- RELACIONAMENTOS PRODUTO
-- =========================
CREATE TABLE PRODUTO_IMAGEM (
  produto_id INT,
  produto_marca_id INT,
  imagem_produto INT,
  CONSTRAINT fk_pi_produto FOREIGN KEY (produto_id) REFERENCES PRODUTOS(idProdutos),
  CONSTRAINT fk_pi_marca FOREIGN KEY (produto_marca_id) REFERENCES PRODUTOS(marcas_id),
  CONSTRAINT fk_pi_imagem FOREIGN KEY (imagem_produto) REFERENCES IMAGEM_PRODUTO(idImagem_produto)
);

CREATE TABLE PRODUTO_CATEGORIA (
  produtos_id INT,
  produtos_marcas_id INT,
  categoria_produtos INT,
  CONSTRAINT fk_pc_produto FOREIGN KEY (produtos_id) REFERENCES PRODUTOS(idProdutos),
  CONSTRAINT fk_pc_marca FOREIGN KEY (produtos_marcas_id) REFERENCES PRODUTOS(marcas_id),
  CONSTRAINT fk_pc_categoria FOREIGN KEY (categoria_produtos) REFERENCES CATEGORIA(idCategoria)
);

-- =========================
-- CUPOM, FRETE, PAGAMENTO
-- =========================
CREATE TABLE CUPOM (
  idCupom INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  valor DOUBLE NOT NULL,
  data_validade DATE NOT NULL,
  quantidade INT NOT NULL
);

CREATE TABLE FRETE (
  idFrete INT PRIMARY KEY AUTO_INCREMENT,
  bairro VARCHAR(45) NOT NULL,
  valor DOUBLE,
  transportadora VARCHAR(45) NOT NULL
);

CREATE TABLE FORMA_PAGAMENTO (
  idForma_pagamento INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(45),
  cupom_id INT,
  CONSTRAINT fk_fp_cupom FOREIGN KEY (cupom_id) REFERENCES CUPOM(idCupom)
);

-- =========================
-- VENDAS
-- =========================
CREATE TABLE VENDAS (
  idVendas INT PRIMARY KEY AUTO_INCREMENT,
  data_venda DATE NOT NULL,
  valor_produto DOUBLE NOT NULL,
  valor_total DOUBLE NOT NULL,
  data_entrega DATE NOT NULL,
  situacao VARCHAR(45) NOT NULL,
  cod_pix VARCHAR(100),
  cod_barras VARCHAR(100),
  valor_total_desconto DOUBLE,
  cliente_id INT NOT NULL,
  forma_pagamento_id INT,
  cupom_id INT,
  frete_id INT,
  CONSTRAINT fk_venda_cliente FOREIGN KEY (cliente_id) REFERENCES CLIENTE(idCliente),
  CONSTRAINT fk_venda_pagamento FOREIGN KEY (forma_pagamento_id) REFERENCES FORMA_PAGAMENTO(idForma_pagamento),
  CONSTRAINT fk_venda_cupom FOREIGN KEY (cupom_id) REFERENCES CUPOM(idCupom),
  CONSTRAINT fk_venda_frete FOREIGN KEY (frete_id) REFERENCES FRETE(idFrete)
);

CREATE TABLE VENDAS_PRODUTOS (
  venda_id INT,
  venda_cliente INT,
  produtos_id INT,
  CONSTRAINT fk_vp_venda FOREIGN KEY (venda_id) REFERENCES VENDAS(idVendas),
  CONSTRAINT fk_vp_cliente FOREIGN KEY (venda_cliente) REFERENCES VENDAS(cliente_id),
  CONSTRAINT fk_vp_produto FOREIGN KEY (produtos_id) REFERENCES PRODUTOS(idProdutos)
);

-- =========================
-- EMPRESA E LOGIN
-- =========================
CREATE TABLE EMPRESA (
  idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
  nome_fantasia VARCHAR(100),
  cnpj_cpf VARCHAR(18),
  telefone VARCHAR(45),
  intagram VARCHAR(100),
  facebook VARCHAR(100),
  whatsapp VARCHAR(100),
  logo LONGBLOB,
  usuario VARCHAR(100),
  senha VARCHAR(12)
);

CREATE TABLE LOGIN_USUARIO (
  idLogin_funcionario INT PRIMARY KEY AUTO_INCREMENT,
  usuario VARCHAR(45) NOT NULL,
  senha VARCHAR(12),
  empresa_id INT,
  CONSTRAINT fk_login_empresa FOREIGN KEY (empresa_id) REFERENCES EMPRESA(idEmpresa)
);

CREATE TABLE BANNERS (
  idBanners INT PRIMARY KEY AUTO_INCREMENT,
  imagem LONGBLOB NOT NULL,
  data_validade DATE NOT NULL,
  descricao VARCHAR(45) NOT NULL,
  link VARCHAR(100),
  categoria_id INT,
  CONSTRAINT fk_banner_categoria FOREIGN KEY (categoria_id) REFERENCES CATEGORIA(idCategoria)
);
