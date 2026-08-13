# FamilyOS - Implementation Plan

## Current State

Date d'inspection : 2026-08-13

Le repository `FamilyHubOS` est un dépôt Git initial, sans commit, sur la branche `main`.

Éléments constatés :

- Aucun fichier applicatif existant.
- Aucun `docker-compose.yml` existant.
- Aucune configuration n8n existante dans le repository.
- Aucune configuration PostgreSQL existante dans le repository.
- Aucun fichier `.env` ou `.env.example`.
- Aucun remote Git configuré.

Contexte VM fourni et recoupé avec les autres projets :

- VM Ubuntu `51.210.40.78`.
- Cluster k3s existant.
- Traefik dans `kube-system` comme reverse proxy public.
- `cert-manager` avec certificats Let's Encrypt.
- Namespace `automation` existant avec `n8n`, `n8n-postgres`, Ingress Traefik et certificat HTTPS.
- Workloads existants dans `default`, `vectis` et probablement `financeos`.

Conclusion : il n'y a actuellement pas d'infrastructure FamilyOS dans ce repository. Pour le MVP, FamilyOS doit utiliser le n8n existant et l'instance PostgreSQL existante `n8n-postgres`, avec une base dédiée `familyos` pour l'état technique.

## Target Architecture

FamilyOS V1 doit rester simple : n8n orchestre les workflows, Notion sert de mémoire métier, Google Calendar planifie les réunions, Telegram sert d'interface, PostgreSQL garde uniquement l'état technique, et le LLM/Web Search sont derrière des sous-workflows remplaçables.

Composants :

- `Telegram` : commandes, boutons, confirmations, notifications.
- `n8n` : orchestrateur central et logique applicative.
- `Notion` : meetings, topics, sources, decisions, feedbacks.
- `Google Calendar` : événements et rappels.
- `PostgreSQL` : executions, erreurs, idempotence, états temporaires.
- `LLM Provider` : génération structurée, abstraction par configuration.
- `Web Search Provider` : recherche normalisée, abstraction par sous-workflow.

Choix recommandé pour le MVP :

- n8n existant dans le namespace Kubernetes `automation`.
- PostgreSQL existant `n8n-postgres`, avec une base dédiée `familyos`.
- Workflows n8n exportés en JSON dans `n8n/workflows/`.
- Configuration métier versionnée dans `config/familyos.config.example.json`.
- Secrets uniquement via n8n credentials et variables d'environnement.
- Documentation d'abord, puis implémentation workflow par workflow.

## Architecture Alternatives

Option A - Tout dans n8n :

- Avantages : rapide, peu de code, adapté au MVP.
- Inconvénients : risque de logique métier dispersée si les workflows grossissent.

Option B - n8n + petit service applicatif :

- Avantages : domaine mieux testé, logique plus maintenable à long terme.
- Inconvénients : plus de maintenance, plus de déploiement, prématuré pour la V1.

Option C - Application complète dès maintenant :

- Avantages : contrôle maximal.
- Inconvénients : coût et complexité inutiles pour valider le rituel familial.

Recommandation : Option A pour le MVP, mais avec une séparation conceptuelle nette via sous-workflows et schémas JSON. Revenir à l'Option B uniquement si la logique métier devient difficile à maintenir dans n8n.

## Proposed Tree

```text
FamilyHubOS/
  IMPLEMENTATION_PLAN.md
  docs/
    architecture.md
    notion-schema.md
    workflows.md
    telegram.md
    setup.md
    security.md
    decisions.md
  config/
    familyos.config.example.json
  n8n/
    workflows/
      FAMILYOS_01_WEEKLY_PLANNER.json
      FAMILYOS_02_RESEARCH.json
      FAMILYOS_03_MEETING_BUILDER.json
      FAMILYOS_04_FOLLOW_UP.json
      FAMILYOS_05_TELEGRAM_ROUTER.json
      FAMILYOS_90_ERROR_HANDLER.json
    subworkflows/
      SUB_CONTEXT_BUILDER.json
      SUB_WEB_SEARCH.json
      SUB_SOURCE_VALIDATOR.json
      SUB_NOTION.json
      SUB_CALENDAR.json
      SUB_NOTIFICATION.json
  infrastructure/
    k8s/
      README.md
      familyos-postgres-init.example.sql
  schemas/
    research-output.schema.json
    source-validation.schema.json
    meeting-builder.schema.json
  tests/
    scenarios/
      mvp.md
  .env.example
  README.md
```

Cette arborescence est cible. Elle ne doit pas être créée entièrement tant que les étapes correspondantes ne sont pas validées.

## MVP Scope

Le MVP couvre uniquement :

1. Interaction Telegram pour choisir automatique/catégorie/sujet.
2. Recherche Internet.
3. Validation des sources.
4. Construction d'une fiche meeting structurée.
5. Création de la page Notion.
6. Création ou mise à jour de l'événement Google Calendar.
7. Confirmation Telegram.

Hors MVP :

- Feedback post-meeting.
- Follow-up des décisions.
- Rotation avancée des catégories.
- RAG ou base vectorielle.
- Dashboard Web.
- Multi-enfants.

## Iterations

### Step 1 - Documentation foundation

Objectif : cadrer l'architecture et le MVP.

Modifications :

- Créer `IMPLEMENTATION_PLAN.md`.
- Créer les documents dans `docs/`.

Test :

- Relire les documents.
- Vérifier que rien d'exécutable ou de sensible n'a été ajouté.

Résultat attendu :

- Une base claire pour implémenter sans surarchitecture.

### Step 2 - Configuration skeleton

Objectif : définir la configuration sans secrets.

Modifications prévues :

- Ajouter `.env.example`.
- Ajouter `config/familyos.config.example.json`.
- Documenter les variables obligatoires.

Test :

- Vérifier qu'aucune vraie valeur secrète n'est présente.

### Step 3 - Docker local baseline

Status : completed as infrastructure documentation baseline.

Objectif : documenter l'intégration avec l'infrastructure k3s existante.

Modifications prévues :

- Ajouter une documentation `infrastructure/k8s/README.md`.
- Documenter le namespace `automation`.
- Documenter l'utilisation de `n8n-postgres`.
- Préparer un SQL exemple pour créer la base dédiée `familyos`, sans l'exécuter automatiquement.

Test :

- Vérification manuelle des commandes Kubernetes à lancer sur la VM.
- Aucun changement réel sur la VM sans inspection préalable.

Résultat :

- `infrastructure/k8s/README.md` documente l'intégration k3s.
- `infrastructure/k8s/familyos-postgres-init.example.sql` définit les tables techniques minimales.

### Step 4 - Notion schema preparation

Status : completed as documentation and mapping baseline.

Objectif : finaliser les bases Notion et mappings n8n.

Modifications prévues :

- Documenter IDs/config attendus.
- Définir propriétés minimales des bases `Meetings`, `Topics`, `Sources`, `Decisions`.

Test :

- Checklist manuelle de création Notion.

Résultat :

- `docs/notion-schema.md` décrit les bases Notion, propriétés, relations, statuts, champs MVP/Phase 2 et mappings n8n.

### Step 5 - Telegram router MVP

Status : skeleton completed.

Prerequisite completed : JSON schema baseline.

Schemas added :

- `schemas/telegram-interaction.schema.json`
- `schemas/source-validation.schema.json`
- `schemas/research-output.schema.json`
- `schemas/meeting-builder.schema.json`

Objectif : router les commandes et callbacks Telegram.

Modifications prévues :

- Créer `FAMILYOS_05_TELEGRAM_ROUTER`.
- Ajouter allowlist `TELEGRAM_ALLOWED_USER_IDS` et `TELEGRAM_ALLOWED_CHAT_IDS`.

Test :

- Utilisateur autorisé.
- Utilisateur non autorisé.
- Commande inconnue.
- Callback double clic.

Résultat :

- `n8n/workflows/FAMILYOS_05_TELEGRAM_ROUTER.json` fournit un routeur Telegram n8n sans credentials.
- `docs/workflows/telegram-router.md` documente le comportement attendu et les scénarios de test.

### Step 6 - Weekly planner MVP

Prerequisite completed : `SUB_CONTEXT_BUILDER` skeleton.

Added :

- `schemas/family-context.schema.json`
- `n8n/subworkflows/SUB_CONTEXT_BUILDER.json`
- `docs/workflows/context-builder.md`

Objectif : proposer catégorie/sujet/automatique.

Modifications prévues :

- Créer `FAMILYOS_01_WEEKLY_PLANNER`.
- Charger contexte familial minimal.
- Envoyer boutons Telegram.

Test :

- Mode automatique.
- Catégorie imposée.
- Sujet imposé.

### Step 7 - Research MVP

Objectif : rechercher et valider des sources.

Modifications prévues :

- Créer `FAMILYOS_02_RESEARCH`.
- Créer `SUB_WEB_SEARCH`.
- Créer `SUB_SOURCE_VALIDATOR`.
- Ajouter schéma JSON strict.

Test :

- Recherche avec résultats.
- Recherche sans résultat.
- Source rejetée.
- JSON invalide.

### Step 8 - Meeting builder MVP

Objectif : générer une fiche meeting fiable et lisible.

Modifications prévues :

- Créer `FAMILYOS_03_MEETING_BUILDER`.
- Produire une structure compatible Notion.

Test :

- Résumé avec sources reliées.
- Avertissement si information non confirmable.

### Step 9 - Notion + Calendar integration

Objectif : créer la page Notion et l'événement Calendar sans doublon.

Modifications prévues :

- Créer `SUB_NOTION`.
- Créer `SUB_CALENDAR`.
- Ajouter idempotency keys.

Test :

- Premier run.
- Retry du même run.
- Erreur Notion.
- Erreur Calendar.

### Step 10 - End-to-end MVP

Objectif : valider la Definition of Done.

Test :

- Telegram -> catégorie Sciences -> 3 sujets -> recherche -> sources -> Notion -> Calendar -> confirmation Telegram.
- Même scénario en mode automatique.
- Même scénario avec sujet directement fourni.

## Import Preparation

Status : completed as skeleton import package.

Files prepared :

- Main workflow exports in `n8n/workflows/`.
- Reusable subworkflow exports in `n8n/subworkflows/`.
- JSON contracts in `schemas/`.
- n8n import guide in `docs/import-n8n.md`.
- Manual MVP scenarios in `tests/scenarios/mvp.md`.

## Open Decisions

- Fournisseur de recherche Web à utiliser pour la V1.
- Fournisseur LLM et modèle initial.
- Fréquence exacte du meeting hebdomadaire.
- Notion workspace et bases existantes ou à créer.
- Calendrier Google cible.
- Stratégie de backup pour la base `familyos` dans `n8n-postgres`.
- Méthode exacte de création de la base `familyos` dans le PostgreSQL existant.
