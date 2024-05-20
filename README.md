![Conecta Logo](https://raw.githubusercontent.com/vihangel/counter_credit/main/assets/favicon.png)
# Conecta Simulação de crédito

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)


Este projeto é uma aplicação moderna desenvolvida para a empresa Conecta, destinada a simular opções de crédito para clientes, gerenciando os dados através do Supabase e hospedada no Firebase. A interface do usuário é construída com Flutter, proporcionando uma experiência fluida e responsiva em múltiplas plataformas.

### Características

- **Simulação de Crédito**: Permite aos usuários simular diferentes opções de crédito baseadas em parâmetros personalizáveis.
- **Gerenciamento de Dados**: Utiliza o Supabase para armazenar e gerenciar todos os dados do aplicativo de forma segura e eficiente.
- **Multiplataforma**: Desenvolvido com Flutter, o aplicativo pode ser executado em iOS, Android e web a partir de uma única base de código.
- **Hospedagem Segura**: Hospedado no Firebase, garantindo alta disponibilidade e desempenho.

### Tecnologias Utilizadas

- **Flutter**: Framework de UI para criar aplicativos nativos compilados.
- **Supabase**: Plataforma open source que oferece um backend substituto ao Firebase com funções de banco de dados e autenticação.
- **Firebase Hosting**: Serviço de hospedagem para web apps que proporciona servidores geodistribuídos, garantindo baixa latência.

### Instalação

Para rodar este projeto localmente, siga os passos abaixo:

1. **Clone o Repositório**
   ```bash
   git clone git@github.com:vihangel/counter_credit.git
   cd counter_credit

2. **Instale as Dependênciaso**
   ```bash
   flutter pub get

3. **Execute o Aplicativo**
   ```bash
   flutter run

### Manutenção e Deploy
Para realizar o deploy do aplicativo na web:

1. **Build da Aplicação**
   ```bash
   flutter build web --release

2. **Deploy no Firebase**
   ```bash
   firebase deploy

#### Nota de Manutenção:
Caso o banco de dados no Supabase fique inativo por 30 dias, pode ser necessário acessar o painel de administração e reativá-lo manualmente.

### Contato
Empresa resposável pelo desenvolvimento: neurocodeltda@gmail.com
