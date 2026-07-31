import { test, expect } from '@playwright/test';

/**
 * Conversation Journey — P1
 *
 * Covers:
 * - Post-connection conversation flow
 *
 * NOTE: Conversations (chat, messaging) are Flutter mobile features.
 * Web app focuses on dashboard and event discovery.
 */
test.describe('Conversation Journey', () => {

  test('[MOBILE] Conversation opens after connection — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'After accepting a connection request, conversation screen opens',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Send a message — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Send a text message in a conversation',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Receive a message — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Receive and display an incoming message',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Yugrow system conversation is pinned — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'AH-019: Yugrow system conversation pinned at top, no duplicates',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Conversation list shows recent chats — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Messages screen shows list of recent conversations with previews',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });
});
