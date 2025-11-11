Demo1 (Parallel) → Final Demo (CIDR-fixed)

Pre-Creation Plan & Approval (Confluence)

Owner: Deshraj
Reviewers: Platform, QA, Security/Infra, Integrations
Goal: Bring up a temporary, parallel environment (demo1) to validate the correct private CIDR (10.30.0.0/16) and third-party network paths. After QA approves, tear down Demo & demo1, then create a fresh Demo on the same 10.30.0.0/16 and keep public names as *.demo.resy.com.

What we’re not doing in this doc: RDS move, load balancers/WAF/IAM/logging details (those are already in IaC and will be created automatically).
Third-parties in scope: MongoDB Atlas, Confluent Cloud (Kafka), Elastic Cloud (Elastico).
Secrets: follow Kent’s guidance—clone for demo1, deletion is not required now.

⸻

0) Summary of the plan
	1.	demo1:
	•	New VPC via network-base with CIDR = 10.30.0.0/16.
	•	New subdomain & wildcard ACM: *.demo1.resy.com via dns stack.
	•	Clone Demo tfvars → demo1 tfvars across all service stacks; clone Pack&Ship packvars (packvars.demo.yaml → packvars.demo1.yaml).
	•	Clone the necessary secrets for demo1.
	•	Connect demo1 to Atlas (peering), Confluent (PL or allowlists), Elastic Cloud (PL/egress) and run QA/regression.
	2.	Decommission:
	•	After QA green, destroy current Demo and demo1 (including peerings/PLs).
	3.	Final Demo:
	•	New VPC via network-base on the same 10.30.0.0/16.
	•	Public DNS/ACM back to *.demo.resy.com via dns stack.
	•	Deploy with Demo tfvars; import/reconnect third-party links as we did for Sandbox.
	•	Smoke + QA, then sign-off.

✅ Using the same CIDR (10.30.0.0/16) for demo1 and the final Demo is fine as long as demo1 is fully torn down (including Atlas peering and PL endpoints) before creating the final Demo. Don’t try to keep both VPCs alive and peered to the same third-parties at the same time with the same CIDR—that creates overlap conflicts.

⸻

1) Decisions & scope
	•	Public names: final environment keeps *.demo.resy.com.
	•	Parallel names: demo1 uses *.demo1.resy.com only for testing.
	•	CIDR: 10.30.0.0/16 for demo1 and the final Demo.
	•	Cutover approach: demo1 is a rehearsal (separate hostname). Final Demo replaces current Demo on the same FQDN.
	•	Third-parties now: configure for demo1 to validate connectivity; import/reconnect again for the final Demo after teardown.
	•	Secrets: clone for demo1; keep or delete later—no pressure to delete now.

⸻

2) Workstreams & exact changes

2.1 Terraform inputs
	•	network-base
	•	Add demo1.tfvars → creates a new VPC (10.30.0.0/16), subnets (public/private/db), NAT gateways, endpoints.
	•	Later add final demo.tfvars (same CIDR) after teardown.
	•	dns
	•	Add demo1.tfvars → creates demo1.resy.com and wildcard ACM *.demo1.resy.com.
	•	Later switch back to demo.tfvars → *.demo.resy.com in the final build.
	•	Service stacks
	•	Clone demo tfvars → demo1 tfvars for each service.
	•	Apply to deploy demo1 into the new VPC.
	•	Pack&Ship
	•	Clone packvars.demo.yaml → packvars.demo1.yaml; rebuild images for demo1.
	•	Later build again with packvars.demo.yaml for the final Demo.
	•	Secrets
	•	Clone the required Parameter Store/Secrets values for demo1 (or point to the same values if appropriate).
	•	Do not delete original Demo secrets now.

⸻

2.2 demo1 build (parallel)
	1.	Create VPC (demo1)
	•	network-base + demo1.tfvars → VPC 10.30.0.0/16, subnets, NAT, endpoints.
	2.	Create DNS & ACM (demo1)
	•	dns + demo1.tfvars → public zone entries for *.demo1.resy.com and wildcard ACM issued/validated.
	3.	Deploy services (demo1)
	•	Clone tfvars and deploy all service stacks to demo1 subnets/SGs.
	4.	Pack&Ship (demo1)
	•	packvars.demo1.yaml → bake and roll out images to demo1.
	5.	Secrets (demo1)
	•	Clone or reference existing secrets/parameters.
	6.	Third-party connectivity (demo1)
	•	MongoDB Atlas: create VPC peering from demo1 VPC; add routes on both sides.
	•	Confluent Cloud: add PrivateLink for demo1 (or confirm Internet/allowlists).
	•	Elastic Cloud: add PrivateLink for demo1 (or confirm Internet/allowlists).
	7.	QA/regression (demo1)
	•	Validate application flows and third-party network paths (Atlas, Confluent, Elastic).

⸻

2.3 Decommission (after demo1 passes)
	•	Destroy current Demo and demo1—including:
	•	VPCs and subnets, NAT, endpoints.
	•	Atlas peering, Confluent PL, Elastic PL for demo1 and old Demo.
	•	demo1.resy.com public DNS & *.demo1.resy.com ACM.

⸻

2.4 Final Demo build (CIDR-fixed)
	1.	Create VPC (final Demo)
	•	network-base + demo.tfvars → VPC 10.30.0.0/16 (fresh), subnets, NAT, endpoints.
	2.	Public DNS & ACM (final)
	•	dns + demo.tfvars → *.demo.resy.com and wildcard ACM (as today).
	3.	Deploy services (final)
	•	Demo tfvars (original names) → deploy to the new VPC.
	4.	Third-party import/reconnect (final)
	•	Atlas: create new peering to the final VPC; add routes; confirm connectivity.
	•	Confluent: add PL (or confirm allowlists) for the final VPC.
	•	Elastic Cloud: add PL (or confirm allowlists) for the final VPC.
	5.	Secrets (final)
	•	Keep canonical /.../demo/... as the long-term paths; reuse the same values.
	•	No deletion required now.
	6.	Smoke & QA
	•	Sanity checks, then QA sign-off.

⸻

3) Acceptance criteria
	•	demo1
	•	VPC created with 10.30.0.0/16 and all service stacks deployed.
	•	Atlas peering established and reachable from demo1.
	•	Confluent connectivity verified (PL or allowlists).
	•	Elastic Cloud connectivity verified (PL or allowlists).
	•	QA regression green.
	•	Final Demo
	•	Fresh VPC with 10.30.0.0/16.
	•	Public DNS/ACM back to *.demo.resy.com.
	•	Third-party connections re-established and verified.
	•	Smoke + QA green.

⸻

4) Risks & mitigations
	•	Overlapping networks with the same CIDR
	•	Risk: Running demo1 and the final Demo (both 10.30/16) at the same time with peering/PL to the same providers can conflict.
	•	Mitigation: Fully tear down demo1 (including peering/PL) before creating the final Demo VPC and its connections.
	•	Third-party lead times/quotas
	•	Risk: Atlas peering / PL endpoints may need approvals or extra capacity.
	•	Mitigation: Create demo1 connections early; schedule final imports immediately after teardown.
	•	DNS/ACM validation time
	•	Risk: ACM validation or DNS propagation can slow you down.
	•	Mitigation: Request ACM for *.demo1.resy.com and prepare *.demo.resy.com validation records ahead of time.
	•	Secrets parity
	•	Risk: A value is missed during demo1 cloning.
	•	Mitigation: Keep a short list of “critical” keys and tick them off during demo1 bring-up; reuse the same values for final.

⸻

5) Tables to fill during execution

A) Terraform inputs (who/when)

Stack	File to add/clone	For demo1	For final Demo	Notes
network-base	demo1.tfvars / demo.tfvars	10.30/16	10.30/16	Final created only after teardown
dns	demo1.tfvars / demo.tfvars	*.demo1.resy.com	*.demo.resy.com	ACM wildcards per env
services (all)	demo → demo1 tfvars clone	✓	back to demo	Same config
pack & ship	packvars.demo → packvars.demo1	✓	back to packvars.demo	Same versions
secrets	clone for demo1	✓	reuse canonical	No deletion required

B) Third-party actions

Provider	demo1 action	final Demo action	Owner	Status
MongoDB Atlas	Create VPC peering to demo1; add routes	Create VPC peering to final; add routes		
Confluent Cloud	Add PL to demo1 (or confirm allowlists)	Add PL to final (or confirm allowlists)		
Elastic Cloud	Add PL to demo1 (or confirm allowlists)	Add PL to final (or confirm allowlists)		

C) QA / approvals

Stage	Checks	Approver	Date
demo1 regression	Core flows + Atlas/Confluent/Elastic connectivity	QA lead	
teardown ready	Demo + demo1 marked for destroy	Platform lead	
final Demo smoke	Core flows + third-party reconnected	QA lead	
final sign-off	All green	Stakeholders	


⸻

6) Day-by-day outline (high level)
	•	Day 1–2: Add demo1.tfvars (network, dns, services); clone packvars; deploy demo1; set up Atlas peering / Confluent PL / Elastic PL; clone secrets; smoke test.
	•	Day 3–4: QA regression on demo1; fix any connectivity gaps.
	•	Go/No-Go: If green → destroy Demo & demo1.
	•	Next day: Create final Demo VPC (10.30/16), public DNS/ACM *.demo.resy.com, deploy services, import/reconnect third-parties; smoke + QA; sign-off.

⸻

Ask for approval

Please review and approve this plan. Once approved, I’ll proceed with:
	•	Creating demo1.tfvars in network-base and dns,
	•	Cloning service tfvars and packvars to demo1,
	•	Setting up Atlas peering / Confluent PL / Elastic PL for demo1,
	•	Running QA, then performing teardown → final Demo build on 10.30.0.0/16 with *.demo.resy.com.
