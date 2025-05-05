# Case Study - Julien CHARLET

Bonjour Ariane, bonjour Mariyem ! 👋

D'abord, merci pour le temps passé à l'étude de ce case study.

Commençons !

<br />

## 📋 Méthodologie globale
1. Appréhension des guidelines du Notion
2. Appréhension des fichiers .csv (compréhension des champs, du lien entre les fichiers)
3. Ingestion des deux fichiers dans Snowflake via la UI
4. Travail des requêtes de modélisation dans la UI pour visualisation des résultats en direct
5. Création d'un projet GitHub, de l'arborescence et des fichiers du projet dbt puis intégration des requêtes
6. Création du template du dashboard sur Miro
7. Création du dashboard sur Tableau

<br />

## 🔎 Méthodologie détaillée

### Modélisation de la donnée
#### ▶ Les tables de staging
> *stg_intercom__conversations*<br />
> *stg_intercom__conversation_parts*

- Renommage des champs pour expliciter l'origine (conversation ou conversation_part) et ainsi éviter les confusions dans les futures jointures
- Nettoyage du champ assigned_to de conversation_parts pour transformation en JSON (remplacement de None en null et des apostrophes en guillemets)
- Extraction de champs dans les colonnes de type JSON (en direct ou en aplatissant des champs à plusieurs niveaux)
- Création de champs de date "_on" en addition des champs "_at" en prévision de futures analyses
- Création de flags (ie. *is_csat_rated*) en prévision du calcul de KPIs
- Organisation des champs pour une meilleure appréhension de la table (via la catégorisation en commentaires)

#### ▶ Les tables intermédiaires
> *int_intercom__messages*

- Agrégation de la staging *stg_intercom__conversation_parts* au niveau conversation_id afin de calculer des KPIs liés aux conversations, utilisables dans l'analyse
- Filtrage de la donnée pour ne garder que les "Messages" et exclure les "bots"
- Identification d'évènements (date du premier message, date de la première réponse)
- Création de calculs (nombre de messages, time to answer)
- Création de flags/info (jour et période de journée de la création du premier message, SLA) en prévision des analyses

> *int_intercom__agg_conversations*
- Agrégation de la staging *stg_intercom__conversations* au niveau conversation_id en supprimant les infos de tags mais en agrégeant le nom des tags à des fins d'analyse
- Cette agrégation permet de conserver le champ conversation_id comme clé primaire dans la table core

> *int_intercom__conversations_tags*
- Agrégation de la staging *stg_intercom__conversations* au niveau conversation_id en ne conservant uniquement les infos de tags
- Cette table pourra être appelée par exemple dans un Explore dans Looker ou via une Relation dans Tableau pour permettre une analyse plus fine des tags, sans dédupliquer les lignes en utilisant la donnée lié aux conversations

#### ▶ La table de dimension
> *dim_team*

- Création d'une table de mapping facilement actionnable dans le but de relier les assignees à leur team

#### ▶ La table core
> *fct_intercom__support_conversations*

- Permet l'analyse au niveau conversation de l'équipe Support rendant faciles les futures agrégations dans un dashboard
- Jointure des tables *int_intercom__agg_conversations*, *int_intercom__messages* et *dim_team*
- Filtrage de la donnée pour ne garder que les conversations assignées à l'équipe Support

#### ▶ Configuration

- Tests sur les clés primaires (conversation_id et conversation_part_id) pour vérifier le remplissage et l'unicité des champs

<br />


### Création du template du dashboard

Le modèle présenté à Lorette est le suivant : 
</br>

<img width="1081" alt="image" src="https://github.com/user-attachments/assets/39393dbc-e676-43ec-af83-6b1ec12b9993" />

<br />
<br />

- L'idée derrière ce modèle de dashboard est de fournir à Lorette un outil non seulement de reporting (extraction de chiffres de manière simple) mais également un outil d'analyse qui lui permette de donner de la profondeur à son analyse hebdomadaire.
- Ce modèle permet également de réduire la taille du dashboard en évitant la multiplication des graphiques : ici, un même graphique lié à un seul KPI peut permettre une analyse en profondeur !

<br />

- Avec un filtre sur la date de création des conversations par défaut sur la semaine précédente, Lorette a accès directement à la performance qui l'intéresse
- On organise le dashboard avec une partie KPIs et une partie Busyness
- Les KPIs seront construits sous forme de triptyques : valeur, breakdown, évolution temporelle (+ breakdown)
  
1. Le paramètre BREAKDOWN permet à Lorette de comparer la performance d'un même KPI d'une dimension choisie
2. Le paramètre GRANULARITY permet à Lorette de choisir la granularité de dates : par défaut en jour pour son analyse hebdo, mais possible de regarder par semaine, mois, trimestre ou année

<br />

Afin de valider le listing de KPIs, il faudra discuter avec Lorette :
- du type de décisions prises lors de ce meeting hebdomadaire
- des incentives de l'équipe : en fonction, il se pourrait qu'on dédie un focus particulier à certains KPIs

Certaines notions seront à éclaircir :
- Au-delà du nombre de conversations dont le time to answer est inférieur à 5 minutes, le temps moyen est-il intéressant ?
- Y aurait-il un intérêt à créer un palier de CSAT ? (par exemple pour analyser le nombre de conversations dont la CSAT est inférieure à 3 ?)
- La CSAT moyenne devrait s'étudier en miroir du taux de réponse
- Comment se calcule le time to close ? (date du dernier message admin ? date d'update de la conversation si state = 'closed' ?)
- Pourrait-on imaginer un regroupement des tags pour une meilleure lisibilité de l'info ?
- Comment gérer les plages horaires des membres de l'équipe dans le calcul des délais de réponse/close ?

On pourrait également proposer à Lorette une analyse de verbatims reccueillis avec la CSAT (via l'équipe Data Science notamment)

<br />


### Création du dashboard

Le modèle développé sur Tableau est le suivant. <br />
Je serai ravi de vous faire une démo en live de son utilisation ! <br />
<br />
Voici quelques exemples de ce qu'il permet de voir :

> Vision Assignee <br />
> Raphaël a traité beaucoup moins de conversations qu'Héloïse mais avec un temps moyen de première réponse beaucoup plus long.
<br />
<img width="1358" alt="image" src="https://github.com/user-attachments/assets/128b2b19-2eb5-4718-9273-fdc7cfecb035" />

<br />
<br />

> Vision Tags / Priority <br />
> Il y a eu cette semaine 74 conversations prioritaires, majoritairement en rapport avec le tag "Permissions". <br />
<br />

<img width="1352" alt="image" src="https://github.com/user-attachments/assets/bfd68452-ab87-4887-9f3f-3b2480d98237" />


