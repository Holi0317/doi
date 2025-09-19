import 'dart:convert';

import 'package:flutter/material.dart';

import '../components/link_tile.dart';
import '../models/link.dart';


const _linkJson = '''
[
  {
    "url": "https://techcommunity.microsoft.com/blog/adforpostgresql/announcing-a-new-ide-for-postgresql-in-vs-code-from-microsoft/4414648",
    "title": "Announcing a new IDE for PostgreSQL in VS Code from Microsoft | Microsoft Community Hub",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 1
  },
  {
    "url": "https://hornetlabs.ca/2025/05/21/pgconf-dev-2025-wraps-up-with-great-success-in-montreal/",
    "title": "pgconf.dev 2025 Wraps Up with Great Success in Montreal – Hornetlabs Technology",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 2
  },
  {
    "url": "https://anonymousdata.medium.com/postman-is-logging-all-your-secrets-and-environment-variables-9c316e92d424",
    "title": "Postman is logging all your secrets and environment variables | by a data scientist | May, 2025 | Me",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 3
  },
  {
    "url": "https://www.theregister.com/2025/05/15/a_year_of_valkey/?utm_source=changelog-news",
    "title": "A year on, Valkey charts path to v9 after break from Redis • The Register",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 4
  },
  {
    "url": "https://1517.substack.com/p/why-bell-labs-worked?utm_source=changelog-news",
    "title": "Why Bell Labs Worked. - by areoform - 1517 Fund",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 5
  },
  {
    "url": "https://holdtherobot.com/blog/2025/05/11/linux-on-android-with-ar-glasses/?utm_source=changelog-news",
    "title": "Coding Without a Laptop - Two Weeks with AR Glasses and Linux on Android | Hold The Robot",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 6
  },
  {
    "url": "https://pscanf.com/s/341/?utm_source=changelog-news",
    "title": "Hyper-Typing",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 7
  },
  {
    "url": "https://blogs.windows.com/windowsdeveloper/2025/05/19/the-windows-subsystem-for-linux-is-now-open-source/?utm_source=changelog-news",
    "title": "The Windows Subsystem for Linux is now open source - Windows Developer Blog",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 8
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/05/aws-advanced-postgresql-odbc-driver-aurora-rds/",
    "title": "New Open-Source AWS Advanced PostgreSQL ODBC Driver now available for Amazon Aurora and RDS - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 9
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/05/amazon-opensearch-ingestion-increases-memory-ocu/",
    "title": "Amazon OpenSearch Ingestion increases memory for an OCU to 15 GB - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 10
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/05/amazon-ecs-1-click-rollbacks-service-deployments/",
    "title": "Amazon ECS introduces 1-click rollbacks for service deployments - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 11
  },
  {
    "url": "https://stormatics.tech/blogs/how-to-safely-perform-backfill-operations-in-timescaledb",
    "title": "How to Safely Perform Backfill Operations in TimescaleDB | Stormatics",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 12
  },
  {
    "url": "https://www.cybertec-postgresql.com/en/create-index-data-types-matter/",
    "title": "CREATE INDEX: Data types matter | CYBERTEC PostgreSQL | Services & Support",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 13
  },
  {
    "url": "https://karenjex.blogspot.com/2025/05/anatomy-of-database-operation.html",
    "title": "Anatomy of a Database Operation",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 14
  },
  {
    "url": "https://mcyoung.xyz/2025/05/13/protobuf-tip-5/",
    "title": "Protobuf Tip #5: Avoid import public/weak · mcyoung",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 15
  },
  {
    "url": "https://awsteele.com/blog/2025/05/07/cloudtrail-wish-almost-granted.html",
    "title": "CloudTrail wish: almost granted | Aidan Steele’s blog (usually about AWS)",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 16
  },
  {
    "url": "https://aws.amazon.com/blogs/big-data/introducing-amazon-q-developer-in-amazon-opensearch-service/",
    "title": "Introducing Amazon Q Developer in Amazon OpenSearch Service | AWS Big Data Blog",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 17
  },
  {
    "url": "https://aws.amazon.com/blogs/database/amazon-cloudwatch-database-insights-applied-in-real-scenarios/",
    "title": "Amazon CloudWatch Database Insights applied in real scenarios | AWS Database Blog",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 18
  },
  {
    "url": "https://aws.amazon.com/blogs/networking-and-content-delivery/united-airlines-implement-enterprise-wide-resilience-program-with-aws/",
    "title": "United Airlines implement enterprise-wide resilience program with AWS | Networking & Content Deliver",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 19
  },
  {
    "url": "https://aws.amazon.com/blogs/storage/bringing-more-to-the-table-how-amazon-s3-tables-rapidly-delivered-new-capabilities-in-the-first-5-months/",
    "title": "Bringing more to the table: How Amazon S3 Tables rapidly delivered new capabilities in the first 5 m",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 20
  },
  {
    "url": "https://deno.com/blog/an-update-on-fresh",
    "title": "An Update on Fresh | Deno",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 21
  },
  {
    "url": "https://engineering.usemotion.com/migrating-to-postgres-3c93dff9c65d",
    "title": "Migrating to Postgres. Since early 2022, Motion was on… | by Sean Callahan | May, 2025 | Motion Engi",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 22
  },
  {
    "url": "https://xata.io/blog/xata-postgres-with-data-branching-and-pii-anonymization",
    "title": "Xata: Postgres with data branching and PII anonymization | xata",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 23
  },
  {
    "url": "https://neon.tech/blog/neon-and-databricks",
    "title": "Neon and Databricks - Neon",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 24
  },
  {
    "url": "https://ultrasciencelabs.com/lab-notes/why-we-are-still-using-88x31-buttons",
    "title": "Why we are still using 88x31 buttons - ultrasciencelabs",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 25
  },
  {
    "url": "https://www.ferretdb.com/",
    "title": "FerretDB",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 26
  },
  {
    "url": "https://www.alexisbouchez.com/blog/http-error-handling-in-go",
    "title": "Centralize HTTP Error Handling in Go | Alexis Bouchez's personal website",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 27
  },
  {
    "url": "https://aws.amazon.com/blogs/aws/accelerate-ci-cd-pipelines-with-the-new-aws-codebuild-docker-server-capability/",
    "title": "Accelerate CI/CD pipelines with the new AWS CodeBuild Docker Server capability | AWS News Blog",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 28
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/05/amazon-vpc-reachability-analyzer-resource-exclusion/",
    "title": "Amazon VPC Reachability Analyzer now supports resource exclusion - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 29
  },
  {
    "url": "https://hire.jonasgalvez.com.br/2025/apr/30/fastify-vue/",
    "title": "The Story of Fastify + Vue",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 30
  },
  {
    "url": "https://nghiant3223.github.io/2025/04/15/go-scheduler.html",
    "title": "Go Scheduler | Melatoni",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 31
  },
  {
    "url": "https://sparklogs.com/",
    "title": "Scalable Cloud Log Management | SparkLogs",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 32
  },
  {
    "url": "https://www.stefanjudis.com/blog/stringly-typed/?utm_source=changelog-news",
    "title": "Stringly Typed",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 33
  },
  {
    "url": "https://raz.sh/blog/2025-05-02_a_critical_look_at_mcp?utm_source=changelog-news",
    "title": "A Critical Look at MCP",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 34
  },
  {
    "url": "https://glasskube.dev/",
    "title": "Distribute your application to self-managed customers | Glasskube",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 35
  },
  {
    "url": "https://zitadel.com/blog/zitadel-v3-announcement",
    "title": "Zitadel v3: AGPL License, Streamlined Releases, and Platform Updates",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 36
  },
  {
    "url": "https://www.kylehailey.com/post/setting-the-record-straight-a-comprehensive-guide-to-understanding-the-aas-metric-in-databases",
    "title": "AAS : THE metric for Monitoring DB Performance",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 37
  },
  {
    "url": "https://oxide.computer/blog/oxides-compensation-model-how-is-it-going?utm_source=changelog-news",
    "title": "Oxide’s Compensation Model: How is it Going? / Oxide",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 38
  },
  {
    "url": "https://github.com/BersisSe/feather?utm_source=changelog-news",
    "title": "BersisSe/feather: Feather🪶: A Rust web framework that does not use async",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 39
  },
  {
    "url": "https://redis.io/blog/agplv3/",
    "title": "Redis is now available under the AGPLv3 open source license",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 40
  },
  {
    "url": "https://antirez.com/news/152",
    "title": "What I learned during the license switch",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 41
  },
  {
    "url": "https://mcyoung.xyz/2025/04/29/protobuf-tip-4/",
    "title": "Protobuf Tip #3: Accepting Mistakes We Can't Fix · mcyoung",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 42
  },
  {
    "url": "https://mcyoung.xyz/2025/04/22/protobuf-tip-3/",
    "title": "Protobuf Tip #3: Enum Names Need Prefixes · mcyoung",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 43
  },
  {
    "url": "https://mcyoung.xyz/2025/04/15/protobuf-tip-2/",
    "title": "Protobuf Tip #2: Compress Your Protos! · mcyoung",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 44
  },
  {
    "url": "https://ardentperf.com/2024/03/03/postgres-indexes-partitioning-and-lwlocklockmanager-scalability/",
    "title": "Postgres Indexes, Partitioning and LWLock:LockManager Scalability | Ardent Performance Computing",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 45
  },
  {
    "url": "https://github.com/cloudnative-pg/cloudnative-pg/discussions/7462",
    "title": "Split-brain in case of network partition · cloudnative-pg/cloudnative-pg · Discussion #7462",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 46
  },
  {
    "url": "https://malai.sh/announcing-malai/",
    "title": "Announcing Malai",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 47
  },
  {
    "url": "https://blog.veeso.dev/blog/en/std-mem-is-interesting/",
    "title": "std::mem is... interesting",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 48
  },
  {
    "url": "https://github.com/grafana/k6/releases/tag/v1.0.0",
    "title": "Release v1.0.0 · grafana/k6",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 49
  },
  {
    "url": "https://mui.com/material-ui/integrations/tailwindcss/tailwindcss-v4/",
    "title": "Tailwind CSS v4 integration - Material UI",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 50
  },
  {
    "url": "https://www.koyeb.com/blog/serverless-postgres-ga-production-ready-databases-for-large-scale-and-ai-apps",
    "title": "Serverless Postgres GA: Production-Ready Databases for Large Scale and AI Apps - Koyeb",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 51
  },
  {
    "url": "https://pganalyze.com/blog/postgres-18-async-io",
    "title": "Waiting for Postgres 18: Accelerating Disk Reads with Asynchronous I/O",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 52
  },
  {
    "url": "https://github.blog/engineering/user-experience/building-a-more-accessible-github-cli/",
    "title": "Building a more accessible GitHub CLI - The GitHub Blog",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 53
  },
  {
    "url": "https://github.com/golang/go/issues/73608",
    "title": "proposal: all: add bare metal support · Issue #73608 · golang/go",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 54
  },
  {
    "url": "https://blog.vaxry.net/articles/2025-electronAintBad",
    "title": "Vaxry's Blog",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 55
  },
  {
    "url": "https://aws.amazon.com/blogs/database/understanding-transaction-visibility-in-postgresql-clusters-with-read-replicas/",
    "title": "Understanding transaction visibility in PostgreSQL clusters with read replicas",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 56
  },
  {
    "url": "https://buttondown.com/jaffray/archive/how-to-understand-that-jepsen-report/?s=09",
    "title": "https://buttondown.com/jaffray/archive/how-to-understand-that-jepsen-report/?s=09",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 57
  },
  {
    "url": "https://jepsen.io/analyses/amazon-rds-for-postgresql-17.4?utm_source=jaffray&utm_medium=email&utm_campaign=how-to-understand-that-jepsen-report",
    "title": "Jepsen: Amazon RDS for PostgreSQL 17.4",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 58
  },
  {
    "url": "https://typescript-is-like-csharp.chrlschn.dev/",
    "title": "TypeScript is Like C#",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 59
  },
  {
    "url": "https://deno.com/blog/add-jsr-with-pnpm-yarn",
    "title": "Add JSR packages with pnpm and Yarn",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 60
  },
  {
    "url": "https://aws.amazon.com/blogs/compute/aws-lambda-standardizes-billing-for-init-phase/",
    "title": "AWS Lambda standardizes billing for INIT Phase | AWS Compute Blog",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 61
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/04/saas-manager-amazon-cloudfront/",
    "title": "Announcing SaaS Manager for Amazon CloudFront - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 62
  },
  {
    "url": "https://blastrock.github.io/fde-tpm-sb.html",
    "title": "The ultimate guide to Full Disk Encryption with TPM and Secure Boot (with hibernation support!)",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 63
  },
  {
    "url": "https://github.com/trufflesecurity/trufflehog",
    "title": "trufflesecurity/trufflehog: Find, verify, and analyze leaked credentials",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 64
  },
  {
    "url": "https://medium.com/jaegertracing/making-design-decisions-for-clickhouse-as-a-core-storage-backend-in-jaeger-62bf90a979d",
    "title": "Making design decisions for ClickHouse as a core storage backend in Jaeger | by Ha Anh Vu | JaegerTr",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 65
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/04/ec2-image-builder-integrates-ssm-parameter-store/",
    "title": "EC2 Image Builder now integrates with SSM Parameter Store - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 66
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/05/amazon-aurora-postgresql-major-version-17/",
    "title": "Amazon Aurora now supports PostgreSQL major version 17 - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 67
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/05/amazon-cloudwatch-tiered-pricing-additional-destinations-aws-lambda-logs/",
    "title": "Amazon CloudWatch launches tiered pricing and additional destinations for AWS Lambda logs - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 68
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/05/amazon-vpc-ipam-cost-distribution-aws-organization-member-accounts/",
    "title": "Amazon VPC IPAM now allows cost distribution to AWS Organization member-accounts - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 69
  },
  {
    "url": "https://antirez.com/news/151",
    "title": "Redis is open source again - ",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 70
  },
  {
    "url": "https://piccalil.li/blog/how-to-write-error-messages-that-actually-help-users-rather-than-frustrate-them/",
    "title": "How to write error messages that actually help users rather than frustrate them - Piccalilli",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 71
  },
  {
    "url": "https://frontendmasters.com/blog/seeking-an-answer-why-cant-html-alone-do-includes/",
    "title": "Seeking an Answer: Why can’t HTML alone do includes? – Frontend Masters Blog",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 72
  },
  {
    "url": "https://github.com/dbgate/dbgate",
    "title": "dbgate/dbgate: Database manager for MySQL, PostgreSQL, SQL Server, MongoDB, SQLite and others. Runs ",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 73
  },
  {
    "url": "https://clickhouse.com/blog/postgres-to-clickhouse-data-modeling-tips-v2",
    "title": "Postgres to ClickHouse: Data Modeling Tips V2",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 74
  },
  {
    "url": "https://www.shayon.dev/post/2025/119/a-postgresql-planner-gotcha-with-ctes-delete-and-limit/",
    "title": "A PostgreSQL planner gotcha with CTEs DELETE and LIMIT",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 75
  },
  {
    "url": "https://jepsen.io/analyses/amazon-rds-for-postgresql-17.4",
    "title": "Jepsen: Amazon RDS for PostgreSQL 17.4",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 76
  },
  {
    "url": "https://old.reddit.com/r/rust/comments/1k6vni5/bugstalker_v030_released_async_debugging_new/",
    "title": "BugStalker v0.3.0 Released – async debugging, new commands & more! : rust",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 77
  },
  {
    "url": "https://medium.com/@alighahremani1377/we-have-polymorphism-at-home-d9f21f5565bf",
    "title": "We have polymorphism at home 🦀!. In Languages like Java, C#, C   and… | by Ali ghahremani | Apr, 202",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 78
  },
  {
    "url": "https://reports.zksecurity.xyz/reports/near-p256/",
    "title": "Audit of the Rust p256 Crate",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 79
  },
  {
    "url": "https://www.thenile.dev/blog/drop-column",
    "title": "What Really Happens When You Drop a Column in Postgres",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 80
  },
  {
    "url": "https://pglite.dev/",
    "title": "PGlite",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 81
  },
  {
    "url": "https://github.com/ansible/awx",
    "title": "ansible/awx",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 82
  },
  {
    "url": "https://okd.io/",
    "title": "Deploy at scale on any Infrastructure",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 83
  },
  {
    "url": "https://www.postgresonline.com/journal/index.php?/archives/421-FROM-function-or-SELECT-function.html",
    "title": "https://www.postgresonline.com/journal/index.php?/archives/421-FROM-function-or-SELECT-function.html",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 84
  },
  {
    "url": "https://www.depesz.com/2025/04/17/waiting-for-postgresql-18-add-modern-sha-2-based-password-hashes-to-pgcrypto/",
    "title": "Waiting for PostgreSQL 18 – Add modern SHA-2 based password hashes to pgcrypto. – select * from depe",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 85
  },
  {
    "url": "https://bdrouvot.github.io/2025/04/02/postgres-backend-statistics-part-2/",
    "title": "Postgres backend statistics (Part 2): WAL statistics",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 86
  },
  {
    "url": "https://karenjex.blogspot.com/2025/04/postgres-on-kubernetes-for-reluctant-dba.html",
    "title": "Postgres on Kubernetes for the Reluctant DBA",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 87
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/04/amazon-ecs-set-default-log-driver-blocking-mode/",
    "title": "Amazon ECS adds the ability to set a default log driver blocking mode - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 88
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/04/aws-sts-global-endpoint-requests-locally-regions-default/",
    "title": "AWS STS global endpoint now serves your requests locally in regions enabled by default - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 89
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/04/automated-http-validated-public-certificates-amazon-cloudfront/",
    "title": "Automated HTTP validated public certificates with Amazon CloudFront - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 90
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/04/amazon-ses-logging-email-sending-events-aws-cloudtrail/",
    "title": "Amazon SES now supports logging email sending events through AWS CloudTrail - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 91
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/04/amazon-cloudfront-anycast-static-ips-apex-domains/",
    "title": "Amazon CloudFront announces Anycast Static IPs support for apex domains - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 92
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/04/iam-identity-center-sdk-plugin-streamline-token-exchange-external-identity-provider/",
    "title": "IAM Identity Center releases new SDK plugin to streamline token exchange with an external Identity P",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 93
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/04/vertical-scaling-amazon-elasticache-memcached/",
    "title": "Announcing vertical scaling in Amazon ElastiCache for Memcached - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 94
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/04/general-availability-quarterly-update-amazon-linux-2023-al2023-7/",
    "title": "Announcing the general availability seventh quarterly update for Amazon Linux 2023 (AL2023), AL2023.",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 95
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/04/amazon-ses-attachments-sending-apis/",
    "title": "Amazon SES now offers attachments in sending APIs - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 96
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/03/amazon-rds-postgresql-configurable-cipher-suites/",
    "title": "Amazon RDS for PostgreSQL now supports configurable cipher suites - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 97
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/03/amazon-eks-new-catalog-community-add-ons/",
    "title": "Amazon EKS introduces a new catalog of community add-ons - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 98
  },
  {
    "url": "https://aws.amazon.com/about-aws/whats-new/2025/04/aws-systems-manager-just-in-time-node-access/",
    "title": "AWS Systems Manager launches just-in-time node access - AWS",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 99
  },
  {
    "url": "https://mcyoung.xyz/2025/04/14/target-triples/",
    "title": "What the Hell Is a Target Triple? · mcyoung",
    "favorite": false,
    "archive": false,
    "created_at": 1758251028000,
    "id": 100
  }
]
''';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _links = (jsonDecode(_linkJson) as List).map((item) => Link.fromJson(item)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Unread (100)'),
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: _links.length,
        itemBuilder: (BuildContext context, int index) {
          return LinkTile(item: _links[index]);
        },
      ),
    );
  }
}
