# Atelier ElasticSearch

Tester la disponibilité du serveur :

<http://nom_du_serveur:5601>

## Premiers pas

A partir de la console Kibana (<http://nom_du_serveur:5601/app/kibana#/dev_tools/console>), ajouter des données :

```json
POST /test/_doc
{
  "prenom" : "Bart",
  "nom" : "Simpson",
  "age": 15

}
```

Tester les données

## Manipuler des données réelles

Télécharger :

- le script [elastic-post-bulk.ps1](../master/elastic-post-bulk.ps1)
- le jeux de données [maires-25-04-2014.json](../master/maires-25-04-2014.json)

Ajouter le mapping suivant :

```json
PUT /maires
{
  "mappings": {
    "properties": {
      "date_de_naissance" : {
        "type": "date",
        "format": "dd/MM/yyyy"
      }
    }
  }
}
```

Exécuter la commande suivante pour insérer les données :

```powershell
.\elastic-post-bulk.ps1 maires-25-04-2014.json http://<nom_du_serveur>:9200/<nom_index>/_bulk <username> <password> 2000
```
