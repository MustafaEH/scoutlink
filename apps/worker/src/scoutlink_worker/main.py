import asyncio
import logging
import signal

from scoutlink_api.core.config import get_settings

logger = logging.getLogger("scoutlink.worker")


async def serve() -> None:
    logging.basicConfig(level=get_settings().log_level)
    stop = asyncio.Event()
    loop = asyncio.get_running_loop()
    for signal_name in (signal.SIGINT, signal.SIGTERM):
        try:
            loop.add_signal_handler(signal_name, stop.set)
        except NotImplementedError:
            pass
    logger.info("ScoutLink worker started")
    await stop.wait()


def run() -> None:
    try:
        asyncio.run(serve())
    except KeyboardInterrupt:
        pass
