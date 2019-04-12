#import <pthread.h>
#import "KittyMemory/MemoryPatch.hpp"


#define ARM64_RET_TRUE "\x20\x00\x80\xD2\xC0\x03\x5F\xD6"


static MemoryPatch minimapPatch;

void *HackThread(void *user_data) {

    // public bool get_CanShowOnMinimap(); // 0x1016BB4F4  ( outdated offset ofc )

      NSLog(@"============  New Patch Entry  =============");
      NSLog(@"============================================");
      NSLog(@"============================================");
	   	   
    // pass NULL as fileName for base executable
    minimapPatch = MemoryPatch(NULL, /* relative address */ 0x1016B6914, /* patch bytes */ ARM64_RET_TRUE, /* patch bytes length */ 8);
	
    // log current bytes
    NSLog(@"get_CanShowOnMinimap Current Bytes: %s", minimapPatch.ToHexString().c_str());
	
    if(minimapPatch.Modify()){ // modify and apply patch bytes
        NSLog(@"get_CanShowOnMinimap has been modified successfully");
		
	// Be aware that bytes will stay same after patch if substrate HookMemory used as it uses some kind of IPC.
	NSLog(@"get_CanShowOnMinimap Current Bytes: %s", minimapPatch.ToHexString().c_str());
    } else {
	NSLog(@"Failed to patch get_CanShowOnMinimap");
    }
	
	
    // for restoring to original bytes
    if(minimapPatch.Restore()){ // restore and apply original bytes
       NSLog(@"get_CanShowOnMinimap has been restored successfully");
       NSLog(@"get_CanShowOnMinimap Current Bytes: %s", minimapPatch.ToHexString().c_str());
    } else {
       NSLog(@"Failed to restore get_CanShowOnMinimap");
    }
	
    return NULL;
}

__attribute__((constructor))
static void runHacksInitializer(){
    pthread_t tid_hack;
    pthread_create(&tid_hack, NULL, HackThread, NULL);
}
