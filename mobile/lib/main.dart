import 'package:flutter/material.dart';
import 'package:mobile/components/link_tile.dart';

import 'container/link.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _links = [
    Link(
      uri: Uri.parse(
        "https://techcommunity.microsoft.com/blog/adforpostgresql/announcing-a-new-ide-for-postgresql-in-vs-code-from-microsoft/4414648",
      ),
      title:
          "Announcing a new IDE for PostgreSQL in VS Code from Microsoft | Microsoft Community Hub",
    ),
    Link(
      uri: Uri.parse(
        "https://hornetlabs.ca/2025/05/21/pgconf-dev-2025-wraps-up-with-great-success-in-montreal/",
      ),
      title:
          "pgconf.dev 2025 Wraps Up with Great Success in Montreal – Hornetlabs Technology",
    ),
    Link(
      uri: Uri.parse(
        "https://anonymousdata.medium.com/postman-is-logging-all-your-secrets-and-environment-variables-9c316e92d424",
      ),
      title:
          "Postman is logging all your secrets and environment variables | by a data scientist | May, 2025 | Me",
    ),
    Link(
      uri: Uri.parse(
        "https://www.theregister.com/2025/05/15/a_year_of_valkey/?utm_source=changelog-news",
      ),
      title:
          "A year on, Valkey charts path to v9 after break from Redis • The Register",
    ),
    Link(
      uri: Uri.parse(
        "https://1517.substack.com/p/why-bell-labs-worked?utm_source=changelog-news",
      ),
      title: "Why Bell Labs Worked. - by areoform - 1517 Fund",
    ),
    Link(
      uri: Uri.parse(
        "https://holdtherobot.com/blog/2025/05/11/linux-on-android-with-ar-glasses/?utm_source=changelog-news",
      ),
      title:
          "Coding Without a Laptop - Two Weeks with AR Glasses and Linux on Android | Hold The Robot",
    ),
    Link(
      uri: Uri.parse("https://pscanf.com/s/341/?utm_source=changelog-news"),
      title: "Hyper-Typing",
    ),
    Link(
      uri: Uri.parse(
        "https://blogs.windows.com/windowsdeveloper/2025/05/19/the-windows-subsystem-for-linux-is-now-open-source/?utm_source=changelog-news",
      ),
      title:
          "The Windows Subsystem for Linux is now open source - Windows Developer Blog",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/05/aws-advanced-postgresql-odbc-driver-aurora-rds/",
      ),
      title:
          "New Open-Source AWS Advanced PostgreSQL ODBC Driver now available for Amazon Aurora and RDS - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/05/amazon-opensearch-ingestion-increases-memory-ocu/",
      ),
      title:
          "Amazon OpenSearch Ingestion increases memory for an OCU to 15 GB - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/05/amazon-ecs-1-click-rollbacks-service-deployments/",
      ),
      title:
          "Amazon ECS introduces 1-click rollbacks for service deployments - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://stormatics.tech/blogs/how-to-safely-perform-backfill-operations-in-timescaledb",
      ),
      title:
          "How to Safely Perform Backfill Operations in TimescaleDB | Stormatics",
    ),
    Link(
      uri: Uri.parse(
        "https://www.cybertec-postgresql.com/en/create-index-data-types-matter/",
      ),
      title:
          "CREATE INDEX: Data types matter | CYBERTEC PostgreSQL | Services & Support",
    ),
    Link(
      uri: Uri.parse(
        "https://karenjex.blogspot.com/2025/05/anatomy-of-database-operation.html",
      ),
      title: "Anatomy of a Database Operation",
    ),
    Link(
      uri: Uri.parse("https://mcyoung.xyz/2025/05/13/protobuf-tip-5/"),
      title: "Protobuf Tip #5: Avoid import public/weak · mcyoung",
    ),
    Link(
      uri: Uri.parse(
        "https://awsteele.com/blog/2025/05/07/cloudtrail-wish-almost-granted.html",
      ),
      title:
          "CloudTrail wish: almost granted | Aidan Steele’s blog (usually about AWS)",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/blogs/big-data/introducing-amazon-q-developer-in-amazon-opensearch-service/",
      ),
      title:
          "Introducing Amazon Q Developer in Amazon OpenSearch Service | AWS Big Data Blog",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/blogs/database/amazon-cloudwatch-database-insights-applied-in-real-scenarios/",
      ),
      title:
          "Amazon CloudWatch Database Insights applied in real scenarios | AWS Database Blog",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/blogs/networking-and-content-delivery/united-airlines-implement-enterprise-wide-resilience-program-with-aws/",
      ),
      title:
          "United Airlines implement enterprise-wide resilience program with AWS | Networking & Content Deliver",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/blogs/storage/bringing-more-to-the-table-how-amazon-s3-tables-rapidly-delivered-new-capabilities-in-the-first-5-months/",
      ),
      title:
          "Bringing more to the table: How Amazon S3 Tables rapidly delivered new capabilities in the first 5 m",
    ),
    Link(
      uri: Uri.parse("https://deno.com/blog/an-update-on-fresh"),
      title: "An Update on Fresh | Deno",
    ),
    Link(
      uri: Uri.parse(
        "https://engineering.usemotion.com/migrating-to-postgres-3c93dff9c65d",
      ),
      title:
          "Migrating to Postgres. Since early 2022, Motion was on… | by Sean Callahan | May, 2025 | Motion Engi",
    ),
    Link(
      uri: Uri.parse(
        "https://xata.io/blog/xata-postgres-with-data-branching-and-pii-anonymization",
      ),
      title: "Xata: Postgres with data branching and PII anonymization | xata",
    ),
    Link(
      uri: Uri.parse("https://neon.tech/blog/neon-and-databricks"),
      title: "Neon and Databricks - Neon",
    ),
    Link(
      uri: Uri.parse(
        "https://ultrasciencelabs.com/lab-notes/why-we-are-still-using-88x31-buttons",
      ),
      title: "Why we are still using 88x31 buttons - ultrasciencelabs",
    ),
    Link(uri: Uri.parse("https://www.ferretdb.com/"), title: "FerretDB"),
    Link(
      uri: Uri.parse(
        "https://www.alexisbouchez.com/blog/http-error-handling-in-go",
      ),
      title:
          "Centralize HTTP Error Handling in Go | Alexis Bouchez's personal website",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/blogs/aws/accelerate-ci-cd-pipelines-with-the-new-aws-codebuild-docker-server-capability/",
      ),
      title:
          "Accelerate CI/CD pipelines with the new AWS CodeBuild Docker Server capability | AWS News Blog",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/05/amazon-vpc-reachability-analyzer-resource-exclusion/",
      ),
      title:
          "Amazon VPC Reachability Analyzer now supports resource exclusion - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://hire.jonasgalvez.com.br/2025/apr/30/fastify-vue/",
      ),
      title: "The Story of Fastify + Vue",
    ),
    Link(
      uri: Uri.parse(
        "https://nghiant3223.github.io/2025/04/15/go-scheduler.html",
      ),
      title: "Go Scheduler | Melatoni",
    ),
    Link(
      uri: Uri.parse("https://sparklogs.com/"),
      title: "Scalable Cloud Log Management | SparkLogs",
    ),
    Link(
      uri: Uri.parse(
        "https://www.stefanjudis.com/blog/stringly-typed/?utm_source=changelog-news",
      ),
      title: "Stringly Typed",
    ),
    Link(
      uri: Uri.parse(
        "https://raz.sh/blog/2025-05-02_a_critical_look_at_mcp?utm_source=changelog-news",
      ),
      title: "A Critical Look at MCP",
    ),
    Link(
      uri: Uri.parse("https://glasskube.dev/"),
      title:
          "Distribute your application to self-managed customers | Glasskube",
    ),
    Link(
      uri: Uri.parse("https://zitadel.com/blog/zitadel-v3-announcement"),
      title:
          "Zitadel v3: AGPL License, Streamlined Releases, and Platform Updates",
    ),
    Link(
      uri: Uri.parse(
        "https://www.kylehailey.com/post/setting-the-record-straight-a-comprehensive-guide-to-understanding-the-aas-metric-in-databases",
      ),
      title: "AAS : THE metric for Monitoring DB Performance",
    ),
    Link(
      uri: Uri.parse(
        "https://oxide.computer/blog/oxides-compensation-model-how-is-it-going?utm_source=changelog-news",
      ),
      title: "Oxide’s Compensation Model: How is it Going? / Oxide",
    ),
    Link(
      uri: Uri.parse(
        "https://github.com/BersisSe/feather?utm_source=changelog-news",
      ),
      title:
          "BersisSe/feather: Feather🪶: A Rust web framework that does not use async",
    ),
    Link(
      uri: Uri.parse("https://redis.io/blog/agplv3/"),
      title: "Redis is now available under the AGPLv3 open source license",
    ),
    Link(
      uri: Uri.parse("https://antirez.com/news/152"),
      title: "What I learned during the license switch",
    ),
    Link(
      uri: Uri.parse("https://mcyoung.xyz/2025/04/29/protobuf-tip-4/"),
      title: "Protobuf Tip #3: Accepting Mistakes We Can't Fix · mcyoung",
    ),
    Link(
      uri: Uri.parse("https://mcyoung.xyz/2025/04/22/protobuf-tip-3/"),
      title: "Protobuf Tip #3: Enum Names Need Prefixes · mcyoung",
    ),
    Link(
      uri: Uri.parse("https://mcyoung.xyz/2025/04/15/protobuf-tip-2/"),
      title: "Protobuf Tip #2: Compress Your Protos! · mcyoung",
    ),
    Link(
      uri: Uri.parse(
        "https://ardentperf.com/2024/03/03/postgres-indexes-partitioning-and-lwlocklockmanager-scalability/",
      ),
      title:
          "Postgres Indexes, Partitioning and LWLock:LockManager Scalability | Ardent Performance Computing",
    ),
    Link(
      uri: Uri.parse(
        "https://github.com/cloudnative-pg/cloudnative-pg/discussions/7462",
      ),
      title:
          "Split-brain in case of network partition · cloudnative-pg/cloudnative-pg · Discussion #7462",
    ),
    Link(
      uri: Uri.parse("https://malai.sh/announcing-malai/"),
      title: "Announcing Malai",
    ),
    Link(
      uri: Uri.parse("https://blog.veeso.dev/blog/en/std-mem-is-interesting/"),
      title: "std::mem is... interesting",
    ),
    Link(
      uri: Uri.parse("https://github.com/grafana/k6/releases/tag/v1.0.0"),
      title: "Release v1.0.0 · grafana/k6",
    ),
    Link(
      uri: Uri.parse(
        "https://mui.com/material-ui/integrations/tailwindcss/tailwindcss-v4/",
      ),
      title: "Tailwind CSS v4 integration - Material UI",
    ),
    Link(
      uri: Uri.parse(
        "https://www.koyeb.com/blog/serverless-postgres-ga-production-ready-databases-for-large-scale-and-ai-apps",
      ),
      title:
          "Serverless Postgres GA: Production-Ready Databases for Large Scale and AI Apps - Koyeb",
    ),
    Link(
      uri: Uri.parse("https://pganalyze.com/blog/postgres-18-async-io"),
      title:
          "Waiting for Postgres 18: Accelerating Disk Reads with Asynchronous I/O",
    ),
    Link(
      uri: Uri.parse(
        "https://github.blog/engineering/user-experience/building-a-more-accessible-github-cli/",
      ),
      title: "Building a more accessible GitHub CLI - The GitHub Blog",
    ),
    Link(
      uri: Uri.parse("https://github.com/golang/go/issues/73608"),
      title: "proposal: all: add bare metal support · Issue #73608 · golang/go",
    ),
    Link(
      uri: Uri.parse("https://blog.vaxry.net/articles/2025-electronAintBad"),
      title: "Vaxry's Blog",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/blogs/database/understanding-transaction-visibility-in-postgresql-clusters-with-read-replicas/",
      ),
      title:
          "Understanding transaction visibility in PostgreSQL clusters with read replicas",
    ),
    Link(
      uri: Uri.parse(
        "https://buttondown.com/jaffray/archive/how-to-understand-that-jepsen-report/?s=09",
      ),
      title:
          "https://buttondown.com/jaffray/archive/how-to-understand-that-jepsen-report/?s=09",
    ),
    Link(
      uri: Uri.parse(
        "https://jepsen.io/analyses/amazon-rds-for-postgresql-17.4?utm_source=jaffray&utm_medium=email&utm_campaign=how-to-understand-that-jepsen-report",
      ),
      title: "Jepsen: Amazon RDS for PostgreSQL 17.4",
    ),
    Link(
      uri: Uri.parse("https://typescript-is-like-csharp.chrlschn.dev/"),
      title: "TypeScript is Like C#",
    ),
    Link(
      uri: Uri.parse("https://deno.com/blog/add-jsr-with-pnpm-yarn"),
      title: "Add JSR packages with pnpm and Yarn",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/blogs/compute/aws-lambda-standardizes-billing-for-init-phase/",
      ),
      title:
          "AWS Lambda standardizes billing for INIT Phase | AWS Compute Blog",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/04/saas-manager-amazon-cloudfront/",
      ),
      title: "Announcing SaaS Manager for Amazon CloudFront - AWS",
    ),
    Link(
      uri: Uri.parse("https://blastrock.github.io/fde-tpm-sb.html"),
      title:
          "The ultimate guide to Full Disk Encryption with TPM and Secure Boot (with hibernation support!)",
    ),
    Link(
      uri: Uri.parse("https://github.com/trufflesecurity/trufflehog"),
      title:
          "trufflesecurity/trufflehog: Find, verify, and analyze leaked credentials",
    ),
    Link(
      uri: Uri.parse(
        "https://medium.com/jaegertracing/making-design-decisions-for-clickhouse-as-a-core-storage-backend-in-jaeger-62bf90a979d",
      ),
      title:
          "Making design decisions for ClickHouse as a core storage backend in Jaeger | by Ha Anh Vu | JaegerTr",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/04/ec2-image-builder-integrates-ssm-parameter-store/",
      ),
      title: "EC2 Image Builder now integrates with SSM Parameter Store - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/05/amazon-aurora-postgresql-major-version-17/",
      ),
      title: "Amazon Aurora now supports PostgreSQL major version 17 - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/05/amazon-cloudwatch-tiered-pricing-additional-destinations-aws-lambda-logs/",
      ),
      title:
          "Amazon CloudWatch launches tiered pricing and additional destinations for AWS Lambda logs - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/05/amazon-vpc-ipam-cost-distribution-aws-organization-member-accounts/",
      ),
      title:
          "Amazon VPC IPAM now allows cost distribution to AWS Organization member-accounts - AWS",
    ),
    Link(
      uri: Uri.parse("https://antirez.com/news/151"),
      title: "Redis is open source again - ",
    ),
    Link(
      uri: Uri.parse(
        "https://piccalil.li/blog/how-to-write-error-messages-that-actually-help-users-rather-than-frustrate-them/",
      ),
      title:
          "How to write error messages that actually help users rather than frustrate them - Piccalilli",
    ),
    Link(
      uri: Uri.parse(
        "https://frontendmasters.com/blog/seeking-an-answer-why-cant-html-alone-do-includes/",
      ),
      title:
          "Seeking an Answer: Why can’t HTML alone do includes? – Frontend Masters Blog",
    ),
    Link(
      uri: Uri.parse("https://github.com/dbgate/dbgate"),
      title:
          "dbgate/dbgate: Database manager for MySQL, PostgreSQL, SQL Server, MongoDB, SQLite and others. Runs ",
    ),
    Link(
      uri: Uri.parse(
        "https://clickhouse.com/blog/postgres-to-clickhouse-data-modeling-tips-v2",
      ),
      title: "Postgres to ClickHouse: Data Modeling Tips V2",
    ),
    Link(
      uri: Uri.parse(
        "https://www.shayon.dev/post/2025/119/a-postgresql-planner-gotcha-with-ctes-delete-and-limit/",
      ),
      title: "A PostgreSQL planner gotcha with CTEs DELETE and LIMIT",
    ),
    Link(
      uri: Uri.parse(
        "https://jepsen.io/analyses/amazon-rds-for-postgresql-17.4",
      ),
      title: "Jepsen: Amazon RDS for PostgreSQL 17.4",
    ),
    Link(
      uri: Uri.parse(
        "https://old.reddit.com/r/rust/comments/1k6vni5/bugstalker_v030_released_async_debugging_new/",
      ),
      title:
          "BugStalker v0.3.0 Released – async debugging, new commands & more! : rust",
    ),
    Link(
      uri: Uri.parse(
        "https://medium.com/@alighahremani1377/we-have-polymorphism-at-home-d9f21f5565bf",
      ),
      title:
          "We have polymorphism at home 🦀!. In Languages like Java, C#, C   and… | by Ali ghahremani | Apr, 202",
    ),
    Link(
      uri: Uri.parse("https://reports.zksecurity.xyz/reports/near-p256/"),
      title: "Audit of the Rust p256 Crate",
    ),
    Link(
      uri: Uri.parse("https://www.thenile.dev/blog/drop-column"),
      title: "What Really Happens When You Drop a Column in Postgres",
    ),
    Link(uri: Uri.parse("https://pglite.dev/"), title: "PGlite"),
    Link(
      uri: Uri.parse("https://github.com/ansible/awx"),
      title: "ansible/awx",
    ),
    Link(
      uri: Uri.parse("https://okd.io/"),
      title: "Deploy at scale on any Infrastructure",
    ),
    Link(
      uri: Uri.parse(
        "https://www.postgresonline.com/journal/index.php?/archives/421-FROM-function-or-SELECT-function.html",
      ),
      title:
          "https://www.postgresonline.com/journal/index.php?/archives/421-FROM-function-or-SELECT-function.html",
    ),
    Link(
      uri: Uri.parse(
        "https://www.depesz.com/2025/04/17/waiting-for-postgresql-18-add-modern-sha-2-based-password-hashes-to-pgcrypto/",
      ),
      title:
          "Waiting for PostgreSQL 18 – Add modern SHA-2 based password hashes to pgcrypto. – select * from depe",
    ),
    Link(
      uri: Uri.parse(
        "https://bdrouvot.github.io/2025/04/02/postgres-backend-statistics-part-2/",
      ),
      title: "Postgres backend statistics (Part 2): WAL statistics",
    ),
    Link(
      uri: Uri.parse(
        "https://karenjex.blogspot.com/2025/04/postgres-on-kubernetes-for-reluctant-dba.html",
      ),
      title: "Postgres on Kubernetes for the Reluctant DBA",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/04/amazon-ecs-set-default-log-driver-blocking-mode/",
      ),
      title:
          "Amazon ECS adds the ability to set a default log driver blocking mode - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/04/aws-sts-global-endpoint-requests-locally-regions-default/",
      ),
      title:
          "AWS STS global endpoint now serves your requests locally in regions enabled by default - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/04/automated-http-validated-public-certificates-amazon-cloudfront/",
      ),
      title:
          "Automated HTTP validated public certificates with Amazon CloudFront - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/04/amazon-ses-logging-email-sending-events-aws-cloudtrail/",
      ),
      title:
          "Amazon SES now supports logging email sending events through AWS CloudTrail - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/04/amazon-cloudfront-anycast-static-ips-apex-domains/",
      ),
      title:
          "Amazon CloudFront announces Anycast Static IPs support for apex domains - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/04/iam-identity-center-sdk-plugin-streamline-token-exchange-external-identity-provider/",
      ),
      title:
          "IAM Identity Center releases new SDK plugin to streamline token exchange with an external Identity P",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/04/vertical-scaling-amazon-elasticache-memcached/",
      ),
      title:
          "Announcing vertical scaling in Amazon ElastiCache for Memcached - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/04/general-availability-quarterly-update-amazon-linux-2023-al2023-7/",
      ),
      title:
          "Announcing the general availability seventh quarterly update for Amazon Linux 2023 (AL2023), AL2023.",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/04/amazon-ses-attachments-sending-apis/",
      ),
      title: "Amazon SES now offers attachments in sending APIs - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/03/amazon-rds-postgresql-configurable-cipher-suites/",
      ),
      title:
          "Amazon RDS for PostgreSQL now supports configurable cipher suites - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/03/amazon-eks-new-catalog-community-add-ons/",
      ),
      title: "Amazon EKS introduces a new catalog of community add-ons - AWS",
    ),
    Link(
      uri: Uri.parse(
        "https://aws.amazon.com/about-aws/whats-new/2025/04/aws-systems-manager-just-in-time-node-access/",
      ),
      title: "AWS Systems Manager launches just-in-time node access - AWS",
    ),
    Link(
      uri: Uri.parse("https://mcyoung.xyz/2025/04/14/target-triples/"),
      title: "What the Hell Is a Target Triple? · mcyoung",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
