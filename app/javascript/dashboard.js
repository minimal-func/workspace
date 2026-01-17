export const initDashboard = () => {
    // Handle form submission
    const form = document.querySelector('.dashboard-form')
    if (form) {
        if (form.dataset.dashboardInitialized) return
        form.dataset.dashboardInitialized = "true"

        form.addEventListener('submit', (e) => {
            const requiredFields = form.querySelectorAll('[required]')
            let isValid = true

            requiredFields.forEach(field => {
                if (!field.value) {
                    isValid = false
                    field.classList.add('error')
                } else {
                    field.classList.remove('error')
                }
            })

            if (!isValid) {
                e.preventDefault()
                alert('Please fill in all required fields')
            }
        })

        // Handle mood, confidence, energy sliders
        const setupSlider = (sliderId, iconId, valueId, hiddenInputId, icons) => {
            const slider = document.getElementById(sliderId)
            const icon = document.getElementById(iconId)
            const valueDisplay = document.getElementById(valueId)
            const hiddenInput = document.getElementById(hiddenInputId)

            if (slider && icon && valueDisplay && hiddenInput) {
                const updateSlider = () => {
                    const val = parseInt(slider.value)
                    valueDisplay.textContent = val
                    hiddenInput.value = val

                    // Update icon based on value range
                    let iconClass = ''
                    if (val <= 2) iconClass = icons[0]
                    else if (val <= 4) iconClass = icons[1]
                    else if (val <= 6) iconClass = icons[2]
                    else if (val <= 8) iconClass = icons[3]
                    else iconClass = icons[4]

                    // Remove all possible icon classes and add the correct one
                    icons.forEach(cls => icon.classList.remove(cls))
                    icon.classList.add(iconClass)
                }

                slider.addEventListener('input', updateSlider)
                updateSlider() // Initialize
            }
        }

        setupSlider('mood-slider', 'mood-icon', 'mood-value-display', 'mood-hidden-input', 
            ['icon-Angry', 'icon-Crying', 'icon-Smile', 'icon-Happy', 'icon-Laughing'])
        
        setupSlider('confidence-slider', 'confidence-icon', 'confidence-value-display', 'confidence-hidden-input',
            ['icon-Target', 'icon-Shield', 'icon-Check', 'icon-Medal', 'icon-Trophy'])

        setupSlider('energy-slider', 'energy-icon', 'energy-value-display', 'energy-hidden-input',
            ['icon-Battery-0', 'icon-Battery-25', 'icon-Battery-50', 'icon-Battery-75', 'icon-Battery-100'])
    }

    // Handle radio button styling (legacy)
    const radioLabels = document.querySelectorAll('.radio-label')
    radioLabels.forEach(label => {
        const radio = label.querySelector('input[type="radio"]')
        if (radio) {
            radio.addEventListener('change', () => {
                radioLabels.forEach(l => l.classList.remove('selected'))
                if (radio.checked) {
                    label.classList.add('selected')
                }
            })
        }
    })
}