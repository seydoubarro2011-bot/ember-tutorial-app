
import { module, test } from 'qunit';
import { setupRenderingTest } from 'supper-rentals/tests/helpers';
import { render } from '@ember/test-helpers';
import Image from 'supper-rentals/components/rental/image';

module('Integration | Component | rental/image', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders the given image', async function (assert) {
    await render(<template>
      <Image
        src="/assets/images/teaching-tomster.png"
        alt="Teaching Tomster"
      />
    </template>);

    assert
      .dom('.image img')
      .exists()
      .hasAttribute('src', '/assets/images/teaching-tomster.png')
      .hasAttribute('alt', 'Teaching Tomster');
  });
});
