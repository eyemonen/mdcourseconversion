# MDCOURSECONVERSION

Dockerfile, joka asentaa Node-alpinen tarvittavat npm-modulit opintojaksojen markdownilla kirjoitettujen materiaalien ja remark-slidejen konvertoimiseksi HTML-sivuiksi. 

Sivujen konversiossa käytetään Mixu/markdown-styles-moduulia, jonka päälle asennetaan eyemonen-coursestyles-layout.
Slidejen konversio tapahtuu backslide-moduulin kautta (sis. remark.js:n).

Lisäksi imageen asennetaan rsync, jotta HTML-exportti voidaan automaattisesti viedä palvelimelle.

## Käyttö

Lokaali markdown-sivujen konversio:

`docker run --rm -v $PWD:/home/mdgen eyemonen/mdcourseconversion generate-md --layout eyemonen-coursestyle --input . --output ./output`

Konvertoidut tiedostot kopioidaan output-hakemistoon.

Lokaali remark-slidejen konversio (hakemistossa, jossa on konvertoitava slidesetti):

`docker run --rm -v $PWD:/home/mdgen eyemonen/mdcourseconversion bs export`

Konvertoidut esitykset kopioidaan dist-hakemistoon.

CircleCI:

Asetettava CircleCI-projektille ympäristömuuttujat SSH_HOST, SSH_USER, TARGET_DIR sekä importattava SSH-avain

```
version: 2
jobs:
  build:
    docker:
      - image: eyemonen/coursestuff
    working_directory: ~/input
    branches:
      only:
        - master
    steps:
      - checkout
      - run: mkdir -p ./output
      - run: generate-md --layout eyemonen-coursestyle --input . --output ./output
      - run: cp -r /home/mdgen/template .
      - run: bs export slidet -o ./output/slidet
      - add_ssh_keys:
          fingerprints: "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
      - run: ssh-keyscan $SSH_HOST >> ~/.ssh/known_hosts
      - run: cd output && rsync -avz --exclude 'private' . $SSH_USER@$SSH_HOST:/home/$SSH_USER/public_html/$TARGET_DIR
```
