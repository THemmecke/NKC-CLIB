 /****************************************************************************
 * drivers/xx_block_drv.c 
 * 
 *             ######### DRIVER SKELETON ###########
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 ****************************************************************************/

/****************************************************************************
 * Included Files
 ****************************************************************************/
#include <errno.h>
#include <drivers.h>
#include "xx_block_drv.h"

/****************************************************************************
 * Pre-processor Definitions
 ****************************************************************************/

/****************************************************************************
 * Private Types
 ****************************************************************************/

/****************************************************************************
 * Private Function Prototypes
 ****************************************************************************/

/****************************************************************************
 * Private Data
 ****************************************************************************/

static const struct block_operations g_bops =
{
  xx_open,     /* open     */
  xx_close,    /* close    */
  xx_read,     /* read     */
  xx_write,    /* write    */
  xx_geometry, /* geometry */
  xx_ioctl     /* ioctl    */
};

/****************************************************************************
 * Private Functions
 ****************************************************************************/

/****************************************************************************
 * Misc Helpers
 ****************************************************************************/

/****************************************************************************
 * Block Driver Methods
 ****************************************************************************/
/****************************************************************************
 * Name: xx_open
 *
 * Description: Open the block device
 *
 ****************************************************************************/

static UINT xx_open(struct _dev *devp)
{

}

/****************************************************************************
 * Name: xx_close
 *
 * Description: close the block device
 *
 ****************************************************************************/

static UINT xx_close(struct _dev *devp)
{

}

/****************************************************************************
 * Name: xx_read
 *
 * Description:
 *   Read the specified numer of sectors from the read-ahead buffer or from
 *   the physical device.
 *
 ****************************************************************************/

static UINT xx_read(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors)
{

}

/****************************************************************************
 * Name: xx_write
 *
 * Description:
 *   Write the specified number of sectors to the write buffer or to the
 *   physical device.
 *
 ****************************************************************************/

static UINT xx_write(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors)
{
 
}


/****************************************************************************
 * Name: xx_geometry
 *
 * Description: Return device geometry
 *
 ****************************************************************************/

static UINT xx_geometry(struct _dev *devp, struct geometry *geometry)
{
 
}

/****************************************************************************
 * Name: xx_ioctl
 *
 * Description: Return device geometry
 *
 ****************************************************************************/

static UINT xx_ioctl(struct _dev *devp, int cmd, unsigned long arg)
{
  
}

/****************************************************************************
 * Initialization/uninitialization/reset
 ****************************************************************************/

int xx_initialize()
{
}
  