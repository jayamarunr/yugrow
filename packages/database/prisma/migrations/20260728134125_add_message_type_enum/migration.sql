/*
  Warnings:

  - You are about to drop the column `orgId` on the `AuditLog` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `AuditLog` table. All the data in the column will be lost.
  - You are about to drop the column `orgId` on the `FeatureFlag` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `Membership` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `Membership` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `Role` table. All the data in the column will be lost.
  - You are about to drop the `Organization` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Permission` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_PermissionToRole` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[workspaceId,key]` on the table `FeatureFlag` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[personId,workspaceId]` on the table `Membership` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[workspaceId,name]` on the table `Role` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `workspaceId` to the `AuditLog` table without a default value. This is not possible if the table is not empty.
  - Added the required column `workspaceId` to the `FeatureFlag` table without a default value. This is not possible if the table is not empty.
  - Added the required column `personId` to the `Membership` table without a default value. This is not possible if the table is not empty.
  - Added the required column `workspaceId` to the `Membership` table without a default value. This is not possible if the table is not empty.
  - Added the required column `workspaceId` to the `Role` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "PersonStatus" AS ENUM ('ACTIVE', 'INVITED', 'DISABLED');

-- CreateEnum
CREATE TYPE "WorkspaceType" AS ENUM ('PERSONAL', 'COMPANY', 'BRAND', 'NONPROFIT', 'COMMUNITY', 'EVENT', 'EDUCATIONAL', 'GOVERNMENT');

-- CreateEnum
CREATE TYPE "WorkspaceStatus" AS ENUM ('ACTIVE', 'TRIAL', 'SUSPENDED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "MembershipType" AS ENUM ('OWNER', 'CO_FOUNDER', 'EMPLOYEE', 'CONTRACTOR', 'CONSULTANT', 'VENDOR', 'AUDITOR', 'PARTNER', 'CUSTOMER', 'INVESTOR');

-- CreateEnum
CREATE TYPE "ProductStatus" AS ENUM ('DEVELOPMENT', 'BETA', 'ACTIVE', 'DEPRECATED');

-- CreateEnum
CREATE TYPE "Visibility" AS ENUM ('PUBLIC', 'PRIVATE', 'HIDDEN');

-- CreateEnum
CREATE TYPE "EventStatus" AS ENUM ('DRAFT', 'ACTIVE', 'COMPLETED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "PresenceStatus" AS ENUM ('ACTIVE', 'EXPIRED');

-- CreateEnum
CREATE TYPE "DomainType" AS ENUM ('SUBDOMAIN', 'CUSTOM', 'WILDCARD');

-- CreateEnum
CREATE TYPE "DomainVerification" AS ENUM ('PENDING', 'VERIFYING', 'VERIFIED', 'FAILED');

-- CreateEnum
CREATE TYPE "SSLStatus" AS ENUM ('PENDING', 'PROVISIONING', 'ACTIVE', 'EXPIRING', 'FAILED');

-- CreateEnum
CREATE TYPE "RelationshipStatus" AS ENUM ('PENDING', 'CONNECTED', 'TRUSTED', 'MUTED', 'BLOCKED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "ConnectionRequestStatus" AS ENUM ('PENDING', 'ACCEPTED', 'DECLINED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "MessageType" AS ENUM ('TEXT', 'SYSTEM', 'RELEASE_NOTE', 'ANNOUNCEMENT', 'FEEDBACK_STATUS');

-- DropForeignKey
ALTER TABLE "Membership" DROP CONSTRAINT "Membership_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "Membership" DROP CONSTRAINT "Membership_userId_fkey";

-- DropForeignKey
ALTER TABLE "Role" DROP CONSTRAINT "Role_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "_PermissionToRole" DROP CONSTRAINT "_PermissionToRole_A_fkey";

-- DropForeignKey
ALTER TABLE "_PermissionToRole" DROP CONSTRAINT "_PermissionToRole_B_fkey";

-- DropIndex
DROP INDEX "AuditLog_orgId_createdAt_idx";

-- DropIndex
DROP INDEX "AuditLog_orgId_idx";

-- DropIndex
DROP INDEX "FeatureFlag_orgId_idx";

-- DropIndex
DROP INDEX "FeatureFlag_orgId_key_key";

-- DropIndex
DROP INDEX "Membership_organizationId_idx";

-- DropIndex
DROP INDEX "Membership_userId_idx";

-- DropIndex
DROP INDEX "Membership_userId_organizationId_key";

-- DropIndex
DROP INDEX "Role_organizationId_idx";

-- DropIndex
DROP INDEX "Role_organizationId_name_key";

-- AlterTable
ALTER TABLE "AuditLog" DROP COLUMN "orgId",
DROP COLUMN "userId",
ADD COLUMN     "actorContext" JSONB DEFAULT '{}',
ADD COLUMN     "personId" TEXT,
ADD COLUMN     "workspaceId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "FeatureFlag" DROP COLUMN "orgId",
ADD COLUMN     "workspaceId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Membership" DROP COLUMN "organizationId",
DROP COLUMN "userId",
ADD COLUMN     "membershipType" "MembershipType" NOT NULL DEFAULT 'EMPLOYEE',
ADD COLUMN     "personId" TEXT NOT NULL,
ADD COLUMN     "workspaceId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Role" DROP COLUMN "organizationId",
ADD COLUMN     "isSystem" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "workspaceId" TEXT NOT NULL;

-- DropTable
DROP TABLE "Organization";

-- DropTable
DROP TABLE "Permission";

-- DropTable
DROP TABLE "User";

-- DropTable
DROP TABLE "_PermissionToRole";

-- DropEnum
DROP TYPE "OrganizationStatus";

-- DropEnum
DROP TYPE "UserStatus";

-- CreateTable
CREATE TABLE "Person" (
    "id" TEXT NOT NULL,
    "authentikId" TEXT,
    "email" TEXT NOT NULL,
    "firstName" TEXT,
    "lastName" TEXT,
    "status" "PersonStatus" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Person_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Workspace" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "type" "WorkspaceType" NOT NULL DEFAULT 'PERSONAL',
    "status" "WorkspaceStatus" NOT NULL DEFAULT 'ACTIVE',
    "logoUrl" TEXT,
    "domain" TEXT,
    "timezone" TEXT DEFAULT 'UTC',
    "locale" TEXT DEFAULT 'en',
    "tier" TEXT DEFAULT 'free',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Workspace_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Capability" (
    "id" TEXT NOT NULL,
    "product" TEXT NOT NULL,
    "resource" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Capability_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CapabilityScope" (
    "id" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "capabilityId" TEXT NOT NULL,
    "attribute" TEXT NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "CapabilityScope_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CapabilityGrant" (
    "id" TEXT NOT NULL,
    "personId" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "capabilityId" TEXT NOT NULL,
    "grantedBy" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "reason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CapabilityGrant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Product" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "version" TEXT NOT NULL DEFAULT '1.0.0',
    "icon" TEXT,
    "status" "ProductStatus" NOT NULL DEFAULT 'DEVELOPMENT',
    "owningEngine" TEXT,
    "ownerWorkspaceId" TEXT,
    "configSchema" JSONB,
    "visibility" "Visibility" NOT NULL DEFAULT 'PUBLIC',
    "discoverable" BOOLEAN NOT NULL DEFAULT true,
    "promotable" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductCapability" (
    "id" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "capability" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "ProductCapability_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductRoute" (
    "id" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "method" TEXT NOT NULL DEFAULT 'GET',
    "description" TEXT,
    "authRequired" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "ProductRoute_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductNavItem" (
    "id" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "href" TEXT NOT NULL,
    "icon" TEXT,
    "parentId" TEXT,
    "requiredCapability" TEXT,
    "order" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "ProductNavItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductFeatureFlag" (
    "id" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "description" TEXT,
    "defaultValue" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "ProductFeatureFlag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductPlanAssignment" (
    "id" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "plan" TEXT NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "ProductPlanAssignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Venue" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "city" TEXT,
    "state" TEXT,
    "country" TEXT,
    "createdByPersonId" TEXT NOT NULL,
    "ownerWorkspaceId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Venue_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Event" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "venueId" TEXT NOT NULL,
    "organizerWorkspaceId" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "status" "EventStatus" NOT NULL DEFAULT 'DRAFT',
    "visibility" "Visibility" NOT NULL DEFAULT 'PUBLIC',
    "discoverable" BOOLEAN NOT NULL DEFAULT true,
    "promotable" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Event_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Presence" (
    "id" TEXT NOT NULL,
    "personId" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "eventId" TEXT NOT NULL,
    "venueId" TEXT NOT NULL,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "status" "PresenceStatus" NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT "Presence_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Domain" (
    "id" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "DomainType" NOT NULL DEFAULT 'SUBDOMAIN',
    "verificationStatus" "DomainVerification" NOT NULL DEFAULT 'PENDING',
    "sslStatus" "SSLStatus" NOT NULL DEFAULT 'PENDING',
    "targetProduct" TEXT,
    "targetRoute" TEXT,
    "environment" TEXT DEFAULT 'production',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Domain_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Route" (
    "id" TEXT NOT NULL,
    "domainId" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "targetType" TEXT NOT NULL,
    "targetId" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Route_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Redirect" (
    "id" TEXT NOT NULL,
    "domainId" TEXT NOT NULL,
    "source" TEXT NOT NULL,
    "destination" TEXT NOT NULL,
    "type" INTEGER NOT NULL DEFAULT 301,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Redirect_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "File" (
    "id" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "size" INTEGER NOT NULL,
    "storageKey" TEXT NOT NULL,
    "url" TEXT,
    "alt" TEXT,
    "width" INTEGER,
    "height" INTEGER,
    "uploadedBy" TEXT NOT NULL,
    "metadata" JSONB DEFAULT '{}',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "File_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RelationshipType" (
    "id" TEXT NOT NULL,
    "workspaceId" TEXT,
    "name" TEXT NOT NULL,
    "category" TEXT,
    "description" TEXT,
    "isSystem" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RelationshipType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Relationship" (
    "id" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "typeId" TEXT NOT NULL,
    "sourceEntityType" TEXT NOT NULL,
    "sourceEntityId" TEXT NOT NULL,
    "targetEntityType" TEXT NOT NULL,
    "targetEntityId" TEXT NOT NULL,
    "status" "RelationshipStatus" NOT NULL DEFAULT 'PENDING',
    "strength" DOUBLE PRECISION NOT NULL DEFAULT 0.5,
    "sourceNotes" TEXT,
    "targetNotes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Relationship_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RelationshipContext" (
    "id" TEXT NOT NULL,
    "relationshipId" TEXT NOT NULL,
    "source" TEXT NOT NULL,
    "sourceDetail" TEXT,
    "firstMetAt" TIMESTAMP(3),
    "tags" TEXT[],
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RelationshipContext_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RelationshipStrengthSignal" (
    "id" TEXT NOT NULL,
    "relationshipId" TEXT NOT NULL,
    "signalType" TEXT NOT NULL,
    "weight" DOUBLE PRECISION NOT NULL,
    "source" TEXT NOT NULL,
    "sourceId" TEXT,
    "timestamp" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RelationshipStrengthSignal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RelationshipTimeline" (
    "id" TEXT NOT NULL,
    "relationshipId" TEXT NOT NULL,
    "eventType" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "sourceEngine" TEXT NOT NULL,
    "sourceId" TEXT,
    "metadata" JSONB DEFAULT '{}',
    "occurredAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RelationshipTimeline_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ConnectionRequest" (
    "id" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "senderPersonId" TEXT NOT NULL,
    "recipientPersonId" TEXT NOT NULL,
    "message" TEXT,
    "status" "ConnectionRequestStatus" NOT NULL DEFAULT 'PENDING',
    "relationshipTypeId" TEXT,
    "expiresAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ConnectionRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Conversation" (
    "id" TEXT NOT NULL,
    "relationshipId" TEXT NOT NULL,
    "contextType" TEXT,
    "contextId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Conversation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Message" (
    "id" TEXT NOT NULL,
    "conversationId" TEXT NOT NULL,
    "senderPersonId" TEXT NOT NULL,
    "type" "MessageType" NOT NULL DEFAULT 'TEXT',
    "content" TEXT NOT NULL,
    "readAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProfessionalIdentity" (
    "id" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "personId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "title" TEXT,
    "company" TEXT,
    "phone" TEXT,
    "email" TEXT,
    "website" TEXT,
    "avatarUrl" TEXT,
    "bio" TEXT,
    "skills" TEXT[],
    "lookingFor" TEXT,
    "services" TEXT[],
    "industries" TEXT[],
    "certifications" JSONB DEFAULT '[]',
    "portfolio" JSONB DEFAULT '[]',
    "socialLinks" JSONB DEFAULT '{}',
    "availability" TEXT,
    "trustScore" DOUBLE PRECISION,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "recommendations" INTEGER NOT NULL DEFAULT 0,
    "design" JSONB DEFAULT '{}',
    "qrCodeUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "ProfessionalIdentity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BusinessCardCollection" (
    "id" TEXT NOT NULL,
    "collectorId" TEXT NOT NULL,
    "cardId" TEXT NOT NULL,
    "relationshipId" TEXT,
    "collectedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BusinessCardCollection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CapabilityToRole" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Person_authentikId_key" ON "Person"("authentikId");

-- CreateIndex
CREATE UNIQUE INDEX "Person_email_key" ON "Person"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Workspace_slug_key" ON "Workspace"("slug");

-- CreateIndex
CREATE INDEX "Capability_product_idx" ON "Capability"("product");

-- CreateIndex
CREATE UNIQUE INDEX "Capability_product_resource_action_key" ON "Capability"("product", "resource", "action");

-- CreateIndex
CREATE INDEX "CapabilityScope_roleId_idx" ON "CapabilityScope"("roleId");

-- CreateIndex
CREATE INDEX "CapabilityScope_capabilityId_idx" ON "CapabilityScope"("capabilityId");

-- CreateIndex
CREATE INDEX "CapabilityGrant_personId_workspaceId_idx" ON "CapabilityGrant"("personId", "workspaceId");

-- CreateIndex
CREATE INDEX "ProductCapability_productId_idx" ON "ProductCapability"("productId");

-- CreateIndex
CREATE UNIQUE INDEX "ProductCapability_productId_capability_key" ON "ProductCapability"("productId", "capability");

-- CreateIndex
CREATE INDEX "ProductRoute_productId_idx" ON "ProductRoute"("productId");

-- CreateIndex
CREATE UNIQUE INDEX "ProductRoute_productId_path_method_key" ON "ProductRoute"("productId", "path", "method");

-- CreateIndex
CREATE INDEX "ProductNavItem_productId_idx" ON "ProductNavItem"("productId");

-- CreateIndex
CREATE INDEX "ProductFeatureFlag_productId_idx" ON "ProductFeatureFlag"("productId");

-- CreateIndex
CREATE UNIQUE INDEX "ProductFeatureFlag_productId_key_key" ON "ProductFeatureFlag"("productId", "key");

-- CreateIndex
CREATE INDEX "ProductPlanAssignment_productId_idx" ON "ProductPlanAssignment"("productId");

-- CreateIndex
CREATE UNIQUE INDEX "ProductPlanAssignment_productId_plan_key" ON "ProductPlanAssignment"("productId", "plan");

-- CreateIndex
CREATE INDEX "Venue_name_idx" ON "Venue"("name");

-- CreateIndex
CREATE INDEX "Venue_city_country_idx" ON "Venue"("city", "country");

-- CreateIndex
CREATE INDEX "Event_venueId_idx" ON "Event"("venueId");

-- CreateIndex
CREATE INDEX "Event_status_idx" ON "Event"("status");

-- CreateIndex
CREATE INDEX "Event_startDate_endDate_idx" ON "Event"("startDate", "endDate");

-- CreateIndex
CREATE INDEX "Presence_eventId_status_idx" ON "Presence"("eventId", "status");

-- CreateIndex
CREATE INDEX "Presence_personId_status_idx" ON "Presence"("personId", "status");

-- CreateIndex
CREATE INDEX "Presence_expiresAt_idx" ON "Presence"("expiresAt");

-- CreateIndex
CREATE UNIQUE INDEX "Domain_name_key" ON "Domain"("name");

-- CreateIndex
CREATE INDEX "Domain_workspaceId_idx" ON "Domain"("workspaceId");

-- CreateIndex
CREATE INDEX "Domain_name_idx" ON "Domain"("name");

-- CreateIndex
CREATE INDEX "Route_domainId_idx" ON "Route"("domainId");

-- CreateIndex
CREATE INDEX "Redirect_domainId_idx" ON "Redirect"("domainId");

-- CreateIndex
CREATE UNIQUE INDEX "File_storageKey_key" ON "File"("storageKey");

-- CreateIndex
CREATE INDEX "File_workspaceId_idx" ON "File"("workspaceId");

-- CreateIndex
CREATE UNIQUE INDEX "RelationshipType_workspaceId_name_key" ON "RelationshipType"("workspaceId", "name");

-- CreateIndex
CREATE INDEX "Relationship_workspaceId_sourceEntityType_sourceEntityId_idx" ON "Relationship"("workspaceId", "sourceEntityType", "sourceEntityId");

-- CreateIndex
CREATE INDEX "Relationship_workspaceId_targetEntityType_targetEntityId_idx" ON "Relationship"("workspaceId", "targetEntityType", "targetEntityId");

-- CreateIndex
CREATE INDEX "Relationship_workspaceId_status_idx" ON "Relationship"("workspaceId", "status");

-- CreateIndex
CREATE INDEX "Relationship_workspaceId_strength_idx" ON "Relationship"("workspaceId", "strength");

-- CreateIndex
CREATE UNIQUE INDEX "Relationship_workspaceId_sourceEntityType_sourceEntityId_ta_key" ON "Relationship"("workspaceId", "sourceEntityType", "sourceEntityId", "targetEntityType", "targetEntityId");

-- CreateIndex
CREATE INDEX "RelationshipContext_relationshipId_idx" ON "RelationshipContext"("relationshipId");

-- CreateIndex
CREATE INDEX "RelationshipStrengthSignal_relationshipId_idx" ON "RelationshipStrengthSignal"("relationshipId");

-- CreateIndex
CREATE INDEX "RelationshipStrengthSignal_relationshipId_signalType_idx" ON "RelationshipStrengthSignal"("relationshipId", "signalType");

-- CreateIndex
CREATE INDEX "RelationshipTimeline_relationshipId_idx" ON "RelationshipTimeline"("relationshipId");

-- CreateIndex
CREATE INDEX "RelationshipTimeline_relationshipId_occurredAt_idx" ON "RelationshipTimeline"("relationshipId", "occurredAt");

-- CreateIndex
CREATE INDEX "ConnectionRequest_workspaceId_recipientPersonId_status_idx" ON "ConnectionRequest"("workspaceId", "recipientPersonId", "status");

-- CreateIndex
CREATE INDEX "ConnectionRequest_workspaceId_senderPersonId_idx" ON "ConnectionRequest"("workspaceId", "senderPersonId");

-- CreateIndex
CREATE INDEX "Conversation_relationshipId_idx" ON "Conversation"("relationshipId");

-- CreateIndex
CREATE INDEX "Message_conversationId_idx" ON "Message"("conversationId");

-- CreateIndex
CREATE INDEX "Message_conversationId_createdAt_idx" ON "Message"("conversationId", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "ProfessionalIdentity_personId_key" ON "ProfessionalIdentity"("personId");

-- CreateIndex
CREATE INDEX "ProfessionalIdentity_workspaceId_idx" ON "ProfessionalIdentity"("workspaceId");

-- CreateIndex
CREATE UNIQUE INDEX "BusinessCardCollection_collectorId_cardId_key" ON "BusinessCardCollection"("collectorId", "cardId");

-- CreateIndex
CREATE UNIQUE INDEX "_CapabilityToRole_AB_unique" ON "_CapabilityToRole"("A", "B");

-- CreateIndex
CREATE INDEX "_CapabilityToRole_B_index" ON "_CapabilityToRole"("B");

-- CreateIndex
CREATE INDEX "AuditLog_workspaceId_idx" ON "AuditLog"("workspaceId");

-- CreateIndex
CREATE INDEX "AuditLog_workspaceId_createdAt_idx" ON "AuditLog"("workspaceId", "createdAt");

-- CreateIndex
CREATE INDEX "FeatureFlag_workspaceId_idx" ON "FeatureFlag"("workspaceId");

-- CreateIndex
CREATE UNIQUE INDEX "FeatureFlag_workspaceId_key_key" ON "FeatureFlag"("workspaceId", "key");

-- CreateIndex
CREATE INDEX "Membership_workspaceId_idx" ON "Membership"("workspaceId");

-- CreateIndex
CREATE INDEX "Membership_personId_idx" ON "Membership"("personId");

-- CreateIndex
CREATE UNIQUE INDEX "Membership_personId_workspaceId_key" ON "Membership"("personId", "workspaceId");

-- CreateIndex
CREATE INDEX "Role_workspaceId_idx" ON "Role"("workspaceId");

-- CreateIndex
CREATE UNIQUE INDEX "Role_workspaceId_name_key" ON "Role"("workspaceId", "name");

-- AddForeignKey
ALTER TABLE "Membership" ADD CONSTRAINT "Membership_personId_fkey" FOREIGN KEY ("personId") REFERENCES "Person"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Membership" ADD CONSTRAINT "Membership_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Role" ADD CONSTRAINT "Role_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductCapability" ADD CONSTRAINT "ProductCapability_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductRoute" ADD CONSTRAINT "ProductRoute_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductNavItem" ADD CONSTRAINT "ProductNavItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductFeatureFlag" ADD CONSTRAINT "ProductFeatureFlag_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductPlanAssignment" ADD CONSTRAINT "ProductPlanAssignment_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Presence" ADD CONSTRAINT "Presence_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FeatureFlag" ADD CONSTRAINT "FeatureFlag_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Domain" ADD CONSTRAINT "Domain_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Route" ADD CONSTRAINT "Route_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "Domain"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Redirect" ADD CONSTRAINT "Redirect_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "Domain"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Relationship" ADD CONSTRAINT "Relationship_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES "RelationshipType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RelationshipContext" ADD CONSTRAINT "RelationshipContext_relationshipId_fkey" FOREIGN KEY ("relationshipId") REFERENCES "Relationship"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RelationshipStrengthSignal" ADD CONSTRAINT "RelationshipStrengthSignal_relationshipId_fkey" FOREIGN KEY ("relationshipId") REFERENCES "Relationship"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RelationshipTimeline" ADD CONSTRAINT "RelationshipTimeline_relationshipId_fkey" FOREIGN KEY ("relationshipId") REFERENCES "Relationship"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "Conversation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CapabilityToRole" ADD CONSTRAINT "_CapabilityToRole_A_fkey" FOREIGN KEY ("A") REFERENCES "Capability"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CapabilityToRole" ADD CONSTRAINT "_CapabilityToRole_B_fkey" FOREIGN KEY ("B") REFERENCES "Role"("id") ON DELETE CASCADE ON UPDATE CASCADE;
