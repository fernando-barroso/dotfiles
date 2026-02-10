import { homedir, hostname } from "os";
import { join } from "path";

const REMOTE_HOST = "shadowfax";
const SERVER_HOSTNAME = "minas-tirith";

// Sound always plays on the laptop (shadowfax), never on the server.
// - On laptop: afplay runs locally
// - On server: SSH's to laptop to run afplay, silent fail if laptop unreachable
const playSound = async ($, soundPath) => {
  if (hostname() === SERVER_HOSTNAME) {
    await $`ssh -o ConnectTimeout=2 -o BatchMode=yes ${REMOTE_HOST} afplay ${soundPath}`
      .nothrow();
  } else {
    await $`afplay ${soundPath}`;
  }
};

export const NotificationPlugin = async ({ $, client }) => {
  const soundPath = join(homedir(), ".config/opencode/sounds/soft-alert.mp3");

  // Check if a session is a main (non-subagent) session
  const isMainSession = async (sessionID) => {
    try {
      const result = await client.session.get({ path: { id: sessionID } });
      const session = result.data ?? result;
      return !session.parentID;
    } catch {
      // If we can't fetch the session, assume it's main to avoid missing notifications
      return true;
    }
  };

  return {
    event: async ({ event }) => {
      // Only notify for main session events, not background subagents
      if (event.type === "session.idle") {
        const sessionID = event.properties.sessionID;
        if (await isMainSession(sessionID)) {
          await playSound($, soundPath);
        }
      }

      // Permission prompt created
      if (event.type === "permission.asked") {
        await playSound($, soundPath);
      }
    },
  };
};
