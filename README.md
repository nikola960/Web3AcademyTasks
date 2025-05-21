Ovaj projekat implementira decentralizovanu autonomnu organizaciju (DAO) gde članstvo predstavlja NFT (ERC721 token). Članovi mogu da kreiraju predloge, glasaju i izvršavaju ih po definisanim pravilima.


Opis projekta

- DAO članstvo je dokazano putem NFT-a (ERC721).
- Svaka adresa može mintovati samo **jedan** NFT po ceni od **0.01 ETH**.
- Prvi NFT se automatski mintuje pri deploy-u kreatoru DAO-a.
- Članovi DAO mogu:
- Kreirati predloge (`createProposal`)
- Glasati za/ protiv (`voteForProposal`)
- Izvršiti predlog (`executeProposal`) ako je odobren nakon isteka roka

Struktura smart contracta

1. MembershipNFT.sol

- Implementacija ERC721 NFT-a sa proširenjem ERC721URIStorage.
- Metadata URI postavlja se tokom mintovanja.
- Enforcuje: 1 NFT po adresi, fiksna cena, automatski ID.

2. DAO.sol

- Sadrži logiku predloga i glasanja.
- Samo vlasnici NFT-a mogu učestvovati.
- Čuva niz predloga i vodi evidenciju glasova.



Deploy podaci

- Mreža: Sepolia  
- Membership NFT contract address: 0xYourNFTContractAddressHere
- DAO contract address: 0xYourDAOContractAddressHere


Metadata (NFT) - IPFS

-IPFS URI za metadata: 
  ipfs://QmYourMetadataHashHere


