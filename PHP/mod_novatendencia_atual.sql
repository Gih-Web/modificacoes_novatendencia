-- ====================================================
-- BANCO DE DADOS: mod_novatendencia (completo e compatível)
-- ====================================================

CREATE DATABASE IF NOT EXISTS mod_novatendencia
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE mod_novatendencia;

-- ====================================================
-- TABELA: CLIENTE
-- ====================================================
CREATE TABLE IF NOT EXISTS CLIENTE (
  idCliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  cpf VARCHAR(14) NOT NULL UNIQUE,
  telefone VARCHAR(20) NOT NULL,
  email VARCHAR(200),
  senha VARCHAR(255),
  foto_perfil LONGBLOB
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: ENDERECO
-- ====================================================
CREATE TABLE IF NOT EXISTS ENDERECO (
  idEndereco INT AUTO_INCREMENT PRIMARY KEY,
  cep VARCHAR(10) NOT NULL,
  cidade VARCHAR(100) NOT NULL,
  numero VARCHAR(20) NOT NULL,
  complemento VARCHAR(100),
  logradouro VARCHAR(100),
  bairro VARCHAR(100),
  tipo VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS CLIENTE_E_ENDERECO (
  cliente_idCliente INT,
  endereco_idEndereco INT,
  FOREIGN KEY (cliente_idCliente) REFERENCES CLIENTE(idCliente),
  FOREIGN KEY (endereco_idEndereco) REFERENCES ENDERECO(idEndereco)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: CATEGORIA
-- ====================================================
CREATE TABLE IF NOT EXISTS CATEGORIA (
  idCategoria INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  desconto DOUBLE DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: MARCAS
-- ====================================================
CREATE TABLE IF NOT EXISTS MARCAS (
  IdMarcas INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL,
  imagem LONGBLOB
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: IMAGEM_PRODUTO
-- ====================================================
CREATE TABLE IF NOT EXISTS IMAGEM_PRODUTO (
  idImagem_produto INT AUTO_INCREMENT PRIMARY KEY,
  foto LONGBLOB,
  tipo VARCHAR(50),
  texto_alternativo VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: PRODUTOS (mantendo novidade, destaque e imagem_produto)
-- ====================================================
CREATE TABLE IF NOT EXISTS PRODUTOS (
  idProdutos INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  imagem_produto LONGBLOB,
  quantidade INT NOT NULL,
  preco DOUBLE NOT NULL,
  tamanho VARCHAR(45),
  cor VARCHAR(45),
  codigo VARCHAR(50) NOT NULL,
  preco_promocional DOUBLE,
  destaque TINYINT(1) DEFAULT 0,
  novidade TINYINT(1) DEFAULT 0,
  marcas_id INT,
  categoria_id INT,
  FOREIGN KEY (marcas_id) REFERENCES MARCAS(IdMarcas),
  FOREIGN KEY (categoria_id) REFERENCES CATEGORIA(idCategoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: produto_categoria
-- ====================================================
CREATE TABLE IF NOT EXISTS produto_categoria (
  idProdutoCategoria INT AUTO_INCREMENT PRIMARY KEY,
  produto_id INT NOT NULL,
  categoria_id INT NOT NULL,
  FOREIGN KEY (produto_id) REFERENCES PRODUTOS(idProdutos) ON DELETE CASCADE,
  FOREIGN KEY (categoria_id) REFERENCES CATEGORIA(idCategoria) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: produto_marca
-- ====================================================
CREATE TABLE IF NOT EXISTS produto_marca (
  idProdutoMarca INT AUTO_INCREMENT PRIMARY KEY,
  produto_id INT NOT NULL,
  marca_id INT NOT NULL,
  FOREIGN KEY (produto_id) REFERENCES PRODUTOS(idProdutos) ON DELETE CASCADE,
  FOREIGN KEY (marca_id) REFERENCES MARCAS(IdMarcas) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: produto_imagem
-- ====================================================
CREATE TABLE IF NOT EXISTS produto_imagem (
  idProdutoImagem INT AUTO_INCREMENT PRIMARY KEY,
  produto_id INT NOT NULL,
  imagem_id INT NOT NULL,
  FOREIGN KEY (produto_id) REFERENCES PRODUTOS(idProdutos) ON DELETE CASCADE,
  FOREIGN KEY (imagem_id) REFERENCES IMAGEM_PRODUTO(idImagem_produto) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- OPCIONAL: produto_tamanho
-- ====================================================
CREATE TABLE IF NOT EXISTS produto_tamanho (
  idProdutoTamanho INT AUTO_INCREMENT PRIMARY KEY,
  produto_id INT NOT NULL,
  tamanho VARCHAR(50),
  FOREIGN KEY (produto_id) REFERENCES PRODUTOS(idProdutos) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- OPCIONAL: produto_cor
-- ====================================================
CREATE TABLE IF NOT EXISTS produto_cor (
  idProdutoCor INT AUTO_INCREMENT PRIMARY KEY,
  produto_id INT NOT NULL,
  cor VARCHAR(50),
  FOREIGN KEY (produto_id) REFERENCES PRODUTOS(idProdutos) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: CUPOM
-- ====================================================
CREATE TABLE IF NOT EXISTS CUPOM (
  idCupom INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL,
  valor DOUBLE NOT NULL,
  data_validade DATE NOT NULL,
  quantidade INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: FRETE
-- ====================================================
CREATE TABLE IF NOT EXISTS FRETE (
  idFrete INT AUTO_INCREMENT PRIMARY KEY,
  bairro VARCHAR(45) NOT NULL,
  valor DOUBLE DEFAULT 0,
  transportadora VARCHAR(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: FORMA_PAGAMENTO
-- ====================================================
CREATE TABLE IF NOT EXISTS FORMA_PAGAMENTO (
  idForma_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: VENDAS
-- ====================================================
CREATE TABLE IF NOT EXISTS VENDAS (
  idVendas INT AUTO_INCREMENT PRIMARY KEY,
  data_venda DATE NOT NULL,
  valor_produto DOUBLE NOT NULL,
  valor_total DOUBLE NOT NULL,
  data_entrega DATE,
  situacao VARCHAR(45) DEFAULT 'Pendente',
  cod_pix VARCHAR(100),
  cod_barras VARCHAR(100),
  valor_total_desconto DOUBLE,
  cliente_id INT NOT NULL,
  forma_pagamento_id INT,
  cupom_id INT,
  frete_id INT,
  FOREIGN KEY (cliente_id) REFERENCES CLIENTE(idCliente),
  FOREIGN KEY (forma_pagamento_id) REFERENCES FORMA_PAGAMENTO(idForma_pagamento),
  FOREIGN KEY (cupom_id) REFERENCES CUPOM(idCupom),
  FOREIGN KEY (frete_id) REFERENCES FRETE(idFrete)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: VENDAS_PRODUTOS
-- ====================================================
CREATE TABLE IF NOT EXISTS VENDAS_PRODUTOS (
  venda_id INT,
  venda_cliente INT,
  produtos_id INT,
  FOREIGN KEY (venda_id) REFERENCES VENDAS(idVendas),
  FOREIGN KEY (venda_cliente) REFERENCES VENDAS(cliente_id),
  FOREIGN KEY (produtos_id) REFERENCES PRODUTOS(idProdutos)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: EMPRESA
-- ====================================================
CREATE TABLE IF NOT EXISTS EMPRESA (
  idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
  nome_fantasia VARCHAR(100) NOT NULL,
  cnpj_cpf VARCHAR(18),
  telefone VARCHAR(45),
  instagram VARCHAR(100),
  facebook VARCHAR(100),
  whatsapp VARCHAR(100),
  logo LONGBLOB,
  usuario VARCHAR(100),
  senha VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: LOGIN_USUARIO
-- ====================================================
CREATE TABLE IF NOT EXISTS LOGIN_USUARIO (
  idLogin_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  usuario VARCHAR(45) NOT NULL,
  senha VARCHAR(255),
  empresa_id INT,
  FOREIGN KEY (empresa_id) REFERENCES EMPRESA(idEmpresa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- TABELA: BANNERS
-- ====================================================
CREATE TABLE IF NOT EXISTS BANNERS (
  idBanners INT AUTO_INCREMENT PRIMARY KEY,
  imagem LONGBLOB NOT NULL,
  data_validade DATE NOT NULL,
  descricao VARCHAR(100) NOT NULL,
  link VARCHAR(255),
  categoria_id INT,
  FOREIGN KEY (categoria_id) REFERENCES CATEGORIA(idCategoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================
-- CONSULTAS TESTE
-- ====================================================
-- SELECT * FROM PRODUTOS;
-- SELECT * FROM CATEGORIA;
-- SELECT * FROM MARCAS;
-- SELECT * FROM produto_categoria;
-- SELECT * FROM produto_marca;
-- SELECT * FROM produto_imagem;

-- ====================================================
-- FIM DO SCRIPT
-- ====================================================

select * from imagem_produto;
