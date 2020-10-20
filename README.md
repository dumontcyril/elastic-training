# Atelier ElasticSearch

Tester la disponibilité du serveur :

<http://nom_du_serveur:5601>

Télécharger :

- le script [elastic-post-bulk.ps1](../blob/master/elastic-post-bulk.ps1)
- le jeux de données [maires-25-04-2014.json](../blob/master/../blob/master/elastic-post-bulk.ps1)

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
